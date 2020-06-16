const fetch = require('node-fetch');

async function cleanVolumes() {
	const volumes = await fetch('https://longhorn.intra.bmw12.ch/v1/volumes', {method: 'GET'})
		.then(res => res.json())
		.then(json => json.data);

	const stoppedReplicas = volumes
		.flat(1)
		.map(volume => volume.replicas.map(replica => ({
			replicaName: replica.name,
			volumeName: volume.name,
			running: replica.running,
			pvcName: volume.kubernetesStatus.pvcName
		})))
		.flat(1)
		.filter(replica => replica.running === false);

	for (const stoppedReplica of stoppedReplicas) {
		try {
			const response = await fetch(
				`https://longhorn.intra.bmw12.ch/v1/volumes/${stoppedReplica.volumeName}?action=replicaRemove`,
				{
					method: 'POST',
					body: JSON.stringify({
						name: stoppedReplica.replicaName
					}),
					headers: {
						'Content-Type': 'application/json',
						'Accept': 'application/json'
					},
				}).then(res => res.json());
			if (response.status) {
				// noinspection ExceptionCaughtLocallyJS
				throw response;
			} else {
				console.log(`deleted replica ${stoppedReplica.replicaName} in pvc: ${stoppedReplica.pvcName}`)
			}
		} catch (e) {
			console.log(`failed to delete replica ${stoppedReplica.replicaName} in pvc: ${stoppedReplica.pvcName}.`, e)
		}
	}
}

module.exports = {
	cleanVolumes
}
