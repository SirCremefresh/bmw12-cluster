const program = require('commander');
const fs = require('fs');
const path = require('path');
const {exec} = require('child_process');

function searchRecursive(dir, pattern) {
	let results = [];

	fs.readdirSync(dir).forEach(function (dirInner) {
		dirInner = path.resolve(dir, dirInner);
		const stat = fs.statSync(dirInner);

		if (stat.isDirectory()) {
			results = results.concat(searchRecursive(dirInner, pattern));
		}

		if (stat.isFile() && dirInner.endsWith(pattern)) {
			results.push(dirInner);
		}
	});

	return results;
}

function getProjectRoot() {
	return path.join(__dirname, '..')
}

function executeCommand(command) {
	return new Promise((res, rej) => {
		exec(command, (error, stdout, stderr) => {
			if (error) {
				rej(error.message)
			} else if (stderr) {
				rej(stderr)
			} else {
				res(stdout)
			}
		});
	})
}

async function encryptAll() {
	const plainFiles = searchRecursive(getProjectRoot(), '.plain');
	for (const plainFile of plainFiles) {
		const parsedFile = path.parse(plainFile);
		const encryptedFile = path.join(parsedFile.dir, `${parsedFile.name}.encrypted`)

		try {
			await executeCommand(`gpg --batch --yes --encrypt --sign --armor -r bmw12 --output ${encryptedFile} ${plainFile}`)
		} catch (e) {
			console.error(`could not encrypt file: ${plainFile}. error: ${e}`)
		}
	}
}

async function decryptAll() {
	const encryptedFiles = searchRecursive(getProjectRoot(), '.encrypted');

	for (const encryptedFile of encryptedFiles) {
		const parsedFile = path.parse(encryptedFile);
		const plainFile = path.join(parsedFile.dir, `${parsedFile.name}.plain`)

		try {
			await executeCommand(`gpg --batch --yes --decrypt -r bmw12 --output ${plainFile} ${encryptedFile}`)
		} catch (e) {
			console.error(`could not decrypt file: ${plainFile}. error: ${e}`)
		}
	}
}

program
	.version('0.0.1')
	.description('Commandline toll for encrypting and decrypting secrets')

program
	.command('encrypt')
	.alias('e')
	.description('Encrypt all the secrets')
	.action(() => encryptAll());

program
	.command('decrypt')
	.alias('d')
	.description('decrypt all the secrets')
	.action(() => decryptAll());

program.parse(process.argv)
