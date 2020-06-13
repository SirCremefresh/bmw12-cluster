const program = require('commander');
const fs = require('fs');
const path = require('path');
const {exec} = require('child_process');
const gpg = require('gpg');

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

async function decryptContent(encryptedContent) {
	return new Promise((resolve, reject) => {
		gpg.decrypt(encryptedContent, ['-r bmw12'], (error, buffer) => {
			if (error)
				reject(error);
			else
				resolve(buffer.toString());
		})
	});
}

async function encryptAllPattern(plainEnding, encryptedEnding) {
	const plainFiles = searchRecursive(getProjectRoot(), plainEnding);
	for (const plainFile of plainFiles) {
		const parsedFile = path.parse(plainFile);
		const encryptedFile = path.join(parsedFile.dir, `${parsedFile.name}${encryptedEnding}`)

		const plainContent = fs.readFileSync(plainFile, 'utf8');

		let plainContentFromEncryptedFile = '';
		if (fs.existsSync(encryptedFile)) {
			plainContentFromEncryptedFile = await decryptContent(fs.readFileSync(encryptedFile, 'utf8'));
		}

		if (plainContent === plainContentFromEncryptedFile) {
			console.log(`content not changed in file: ${plainFile}`);
			continue;
		} else {
			console.log(`content changed in file: ${plainFile}`);
		}

		try {
			await executeCommand(`gpg --batch --yes --encrypt --sign --armor -r bmw12 --output ${encryptedFile} ${plainFile}`)
		} catch (e) {
			console.error(`could not encrypt file: ${plainFile}. error: ${e}`)
		}
	}
}

async function decryptAllPattern(encryptedEnding, plainEnding) {
	const encryptedFiles = searchRecursive(getProjectRoot(), encryptedEnding);

	for (const encryptedFile of encryptedFiles) {
		const parsedFile = path.parse(encryptedFile);
		const plainFile = path.join(parsedFile.dir, `${parsedFile.name}${plainEnding}`)

		try {
			await executeCommand(`gpg --batch --yes --decrypt -r bmw12 --output ${plainFile} ${encryptedFile}`)
		} catch (e) {
			console.error(`could not decrypt file: ${plainFile}. error: ${e}`)
		}
	}
}

async function encryptAll() {
	await encryptAllPattern('.plain', '.encrypted')
	await encryptAllPattern('.plain-yaml', '.encrypted-yaml')
}

async function decryptAll() {
	await decryptAllPattern('.encrypted', '.plain')
	await decryptAllPattern('.encrypted-yaml', '.plain-yaml')
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
