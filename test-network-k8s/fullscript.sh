# #Create kind cluster
# echo "Creating cluster KIND"

# cd ..
# kind create cluster

# # export ORG=Org1
# # chmod +x network

# cd ./test-network-k8s

# echo "Initializing network files"
# ./network kind
# ./network cluster init

#Create org and add peers to network
echo "Creating orgo org1 org2 org3 and peers"
./network up

#adding org1 org2 org3 to mychannel
echo "Adding org0 org1 org2 org3 to mychannel"
./network channel create

#installing chaincode in org1
echo "Deploying chaincode in org1"
./network chaincode deploy asset-transfer-basic ../asset-transfer-basic/chaincode-java


export ORG=Org2
chmod +x network

# Installing chaincode in org2
echo "Deploying chaincode in org2"
./network chaincode deploy asset-transfer-basic ../asset-transfer-basic/chaincode-java

export ORG=Org3
chmod +x network

# Installing chaincode in org3
echo "Deploying chaincode in org3"
./network chaincode deploy asset-transfer-basic ../asset-transfer-basic/chaincode-java

echo "Done"

