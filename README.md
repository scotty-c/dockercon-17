# DockerCon 2017 
```
Prerequisites:
- Vagrant
- Ruby
```

## The architecture
This repo will build a three node UCP cluster and a one node open source swarm cluster. On the first node we will install UCP, we will then deploy a consul container which we will use as the key/value store for the Docker network "swarm-private".The next two nodes will join the UCP cluster and set up all the tls for authentication. Then we will deploy the Jenkins 2.0 with Docker Compose using interlock as the entry point. Jenkins will then have a build job to deploy a demo web app.
This will all be built with Puppet. 

Grab a trial license key for Docker data centre and copy it into docker_subscription.lic

# Run the environment
```
git clone https://github.com/scotty-c/dockercon-17.git && cd dockercon-17
vagrant up
echo "172.17.10.102 jenkins.ucp-demo.local">>/etc/hosts && echo "172.17.10.102 webapp.ucp-demo.local">>/etc/hosts 
```

# Access to the UCP console
```
https://172.17.10.101


Username : admin
Password : orca4307
```

# Access to the Jenkins console
```
http://jenkins.ucp-demo.local/

username: admin
password: admin
```

# Access to the demo web app
```
http://webapp.ucp-demo.local/
```


