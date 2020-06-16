#!/usr/bin/env node

const program = require('commander');
const {decryptAll, encryptAll} = require('./src/secrets');
const {cleanVolumes, deleteVolume} = require('./src/volumes');


program
	.version('0.0.1')
	.description('Commandline toll for some easy things in the bmw12-cluster')

const secretsCommand = program
	.command('secrets')
	.aliases(['s', 'secret'])
	.description('for encrypting and decrypting secrets');

secretsCommand
	.command('encrypt')
	.alias('e')
	.description('Encrypt all the secrets')
	.action(() => encryptAll());

secretsCommand
	.command('decrypt')
	.alias('d')
	.description('decrypt all the secrets')
	.action(() => decryptAll());


const volumesCommand = program.command('volumes')
	.aliases(['v', 'volume'])
	.description('for managing longhorn volumes')

volumesCommand
	.command('clean')
	.description('deletes stopped replicas')
	.action(() => cleanVolumes())

volumesCommand
	.command('delete <volume>')
	.description('delete volume')
	.action((volume) => deleteVolume(volume))

program.parse(process.argv)
