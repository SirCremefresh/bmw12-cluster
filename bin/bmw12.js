#!/usr/bin/env node

const program = require('commander');
const {decryptAll} = require('./secrets');
const {encryptAll} = require('./secrets');


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
