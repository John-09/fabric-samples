const express = require("express");
const app = express();
const port = 3000;
const cors = require("cors");
require("dotenv").config();
const jwt = require("jsonwebtoken");
const cookieParser = require("cookie-parser");
const http = require("http");
// const socketio = require("socket.io");
const bodyParser = require("body-parser");
// const io = require("socket.io")(http);
// const auth = require("./controllers/utils/login.js");
const { spawn } = require('child_process');
const { uptime, stdout, exit } = require("process");
const { exec } = require("child_process");
async function main() {
  app.use(cors());
  app.use(express.json());
  app.use(bodyParser.json());
  app.options("*", cors());
  app.use(
    express.urlencoded({
      extended: false,
    })
  );
  app.use(cookieParser());

  app.get("/defaultNetwork", (req, res) => {
    console.log("entered template");
    const child = exec("./fullscript.sh", { cwd: "../" });
    this.commom_emit(req, res, child);
  });

  app.get("/kindInit", (req, res) => {
    console.log("entered create_template");
    // check if cluster exists
    check_cluster();
    if (stdout === "Cluster exists") {
      console.log("cluster exists");
      res.status(200).send("Cluster exists");
    } else {
      console.log("cluster does not exist");
      console.log("creating cluster");
      //how to run shell script from nodejs
      const { spawn } = require("child_process");
      const cmd = spawn("./network", ["kind"], { cwd: "../" });
      cmd.stdout.pipe(res);
      cmd.stderr.pipe(res);
      cmd.on("close", (code) => {
        console.log(`child process exited with code ${code}`);
        // network cluster init
        const cmd2 = spawn("./network", ["cluster", "init"], { cwd: "../" });
        cmd2.stdout.pipe(res);
        cmd2.stderr.pipe(res);
        cmd2.on("close", (code) => {
          console.log(`child process exited with code ${code}`);
          res.status(200).send("Cluster created");
        });
      });
    }
  });

  app.get("/check_cluster", (req, res) => {
    const { exec } = require("child_process");
    exec("kubectl get pods -A", (err, stdout, stderr) => {
      if (err) {
        //some err occurred
        console.error(err);
        console.log(stderr); // print out the standard error output
        res.status(500).send("Error occurred while executing command");
      } else {
        console.log("cluster exists", stdout);
        console.log(`stdout: ${stdout}`);
        // res.send("cluster exists", stdout);
        // Split the string into an array of lines
        const lines = stdout.trim().split("\n");
        // Extract the header row to use as the keys for the object
        const headers = lines[0].split(/\s+/);
        // Create an array of objects, one for each line after the header row
        const result = lines.slice(1).map((line) => {
          const values = line.trim().split(/\s+/);
          return headers.reduce((obj, key, index) => {
            obj[key] = values[index];
            return obj;
          }, {});
        });
        console.log(stdout);
        res.status(200).json({
          message: "cluster exists",
          stdout: result,
        });
      }
    });
  });

  check_cluster = async () => {
    const { exec } = require("child_process");
    exec("kubectl get pods -A", (err, stdout, stderr) => {
      if (err) {
        //some err occurred
        console.error(err);
        console.log(stderr); // print out the standard error output
        return "Cluster does not exist";
      } else {
        console.log("cluster exists", stdout);
        console.log(`stdout: ${stdout}`);
        return "Cluster exists";
        // res.send("cluster exists", stdout);
      }
    });
  };


  app.post("/createOrg", async (req, res) => {
    console.log("Creating org");
    let responseSent = false; // added variable to track if response has been sent
    try {
      const { ORG_NAME, NAMESPACE } = req.body;
      const child1 = exec("./change.sh", {
        cwd: "../",
        env: {
          ...process.env,
          ORG_NAME: ORG_NAME,
          NAMESPACE: NAMESPACE,
        },
      });
  
      child1.stdout.on("data", (data) => {
        console.log(`stdout: ${data}`);
        if (!responseSent) { // check if response has been sent before sending again
          res.write(data);
        }
      });
  
      child1.stderr.on("data", (data) => {
        console.error(`stderr: ${data}`);
        if (!responseSent) {
          res.write(data);
        }
      });
  
      const child = spawn("./network1.sh", ["up"], {
        cwd: "../",
        env: {
          ...process.env,
          ORG_NAME: ORG_NAME,
          NAMESPACE: NAMESPACE,
        },
      });
  
      child.stderr.on("data", (data) => {
        console.error(`stderr: ${data}`);
      });
  
      child.on("close", (code) => {
        console.log(`child process exited with code ${code}`);
        if (!responseSent) {
          responseSent = true;
          if (code === 0) {
            res.status(200).send("Organization created successfully");
          } else {
            res.status(500).send(`Error creating organization: ${code}`);
          }
        }
      });
    } catch (error) {
      console.error(`Error parsing request body: ${error}`);
      if (!responseSent) {
        res.status(400).send("Error parsing request body");
      }
    }
  });

  app.post('/createChannel', (req, res) => {
    const { ORG_CHANNEL, ORG_NAME, NAMESPACE } = req.body;
  
    const createChannel = spawn('./network1.sh', ['channel', 'create', '-c'], {
      cwd: "../",
      env: {
        ...process.env,
        ORG_CHANNEL: ORG_CHANNEL,
        ORG_NAME:ORG_NAME,
        NAMESPACE:NAMESPACE
      }
    });
  
    createChannel.on('close', (code) => {
      if (code === 0) {
        defaultChannel(ORG_NAME, NAMESPACE);
        res.status(200).send('Channel created successfully.');
      } else {
        res.status(500).send('Failed to create channel.');
      }
    });
  });

  function defaultChannel(ORG_NAME, NAMESPACE) {
    const { exec } = require('child_process');
  
    exec(`export ORG_CHANNEL=hyperbase && export ORG_NAME=${ORG_NAME} && export NAMESPACE=${NAMESPACE}  && cd .. && ./network1.sh channeldefault create`, (err, stdout, stderr) => {
      if (err) {
        console.error(`Error executing script: ${err}`);
        return;
      }
      console.log(stdout);
    });
  }

  app.post('/deployChaincode', (req, res) => {
    // const cmd = req.body.cmd;
    const {ORG_NAME, NAMESPACE ,ORG_CHANNEL ,CHAINCODE_NAME} = req.body;
  
    const deployChaincode = spawn('./network1.sh', ['chaincode', 'deploy', CHAINCODE_NAME, '../asset-transfer-basic/chaincode-java'], {
      cwd: '../',
      env: {
        ...process.env,
        ORG_NAME:ORG_NAME,
        NAMESPACE:NAMESPACE,
        ORG_CHANNEL:ORG_CHANNEL,
        CHAINCODE_NAME: CHAINCODE_NAME
      },
    });
  
    deployChaincode.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });
  
    deployChaincode.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });
  
    deployChaincode.on('error', (error) => {
      console.error(`error: ${error.message}`);
      return res.status(500).json({ error: 'Failed to deploy chaincode.' });
    });
  
    deployChaincode.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
      return res.status(200).json({ message: 'Chaincode deployed successfully.' });
    });
  });


app.post('/query', (req, res) => {
  const { ORG_NAME,NAMESPACE ,ORG_CHANNEL ,CHAINCODE_NAME, ARGS } = req.body;

  // Set environment variables from request body
  const env = {
    ORG_NAME:ORG_NAME,
    NAMESPACE:NAMESPACE,
    ORG_CHANNEL:ORG_CHANNEL,
    CHAINCODE_NAME: CHAINCODE_NAME,
    ARGS: ARGS
  };

  // Execute the invoke command
  const invokeCmd = `sh -c "./network1.sh chaincode invoke $CHAINCODE_NAME '{\\"Args\\":[\\"InitLedger\\"]}'"`;
  exec(invokeCmd,{ cwd: '../', env }, (err, stdout, stderr) => {
    if (err) {
      console.error(`Error executing command: ${invokeCmd}`);
      console.error(stderr);
      return res.status(500).send({ error: 'Error invoking chaincode' });
    }

    console.log(`Successfully invoked chaincode ${CHAINCODE_NAME}`);

    // Execute the query command
    const queryCmd = `./network1.sh chaincode query $CHAINCODE_NAME $ARGS`;
    exec(queryCmd, { cwd: '../', env }, (err, stdout, stderr) => {
      if (err) {
        console.error(`Error executing command: ${queryCmd}`);
        console.error(stderr);
        return res.status(500).send({ error: 'Error querying chaincode' });
      }

      console.log(`Successfully queried chaincode ${CHAINCODE_NAME}`);
      res.send({ result: stdout });
    });
  });
});

  app.get("/teardown_network", (req, res) => {
    const { spawn } = require("child_process");
    const cmd = spawn("./network", ["down"], { cwd: "../" });
    this.commom_emit(req, res, cmd);
  });

  app.post("/deleteOrgCerd", (req, res) => {
    const { spawn } = require("child_process");
    const { ORG_NAME, NAMESPACE } = req.body;
    const child = spawn("./network1.sh", ["down"], {
      cwd: "../",
      env: {
        ...process.env,
        ORG_NAME: ORG_NAME,
        NAMESPACE: NAMESPACE,
      },
    });

    this.commom_emit(req, res, child);
  });

  app.get("/network_unkind", (req, res) => {
    const { spawn } = require("child_process");
    const cmd = spawn("./network", ["unkind"], { cwd: "../" });

    this.commom_emit(req, res, cmd);
  });

  commom_emit = async (req, res, cmd) => {
    res.setHeader("Content-Type", "application/json");
    res.setHeader("Connection", "keep-alive");
    res.setHeader("Transfer-Encoding", "chunked");

    // cmd.stdout.on("data", (data) => {
    //   console.log(`stdout: ${data}`);
    //   res.write(data);
    // });
    cmd.stdout.pipe(res);
    // cmd.stdout.on("data", (data) => {
    //   console.log(`stdout: ${data}`);
    //   // res.write(data);
    // });
    cmd.stdout.on("data", (data) => {
      console.log(`stdout: ${data}`);
      // res.write(data);
    });

    cmd.stderr.on("data", (data) => {
      console.error(`stderr: ${data}`);
      res.write(data);
    });

    // cmd.on("close", (code) => {
    //   console.log(`child process exited with code ${code}`);
    //   res.end();
    // });

    cmd.on("close", (code) => {
      console.log(`child process exited with code ${code}`);
      res.end();
    });

    // res.end();
  };

  app.listen(port, () => {
    console.log("Server is listening");
  });
}

main();



// query
// login