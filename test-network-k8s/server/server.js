const express = require("express");
const app = express();
const port = 3000;
const cors = require("cors");
require("dotenv").config();
const jwt = require("jsonwebtoken");
const cookieParser = require("cookie-parser");
const http = require("http");
const socketio = require("socket.io");

// const auth = require("./controllers/utils/login.js");
const { uptime, stdout, exit } = require("process");
const { exec } = require("child_process");
async function main() {
  app.use(cors());
  app.use(express.json());
  app.options("*", cors());
  app.use(
    express.urlencoded({
      extended: false,
    })
  );
  app.use(cookieParser());

  cluster_creation = async () => {
    const { exec } = require("child_process");
    exec(
      "./network kind \
       ./network cluster init ",
      (err, stdout, stderr) => {
        if (err) {
          //some err occurred
          console.error(err);
        } else {
          // the entire stdout and stderr (buffered)
          console.log(`stdout: ${stdout}`);
          console.log(`stderr: ${stderr}`);
        }
      }
    );
  };

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
  app.get("/test", (req, res) => {
    const { exec } = require("child_process");
    exec("kubectl get pods -A", (err, stdout, stderr) => {
      if (err) {
        //some err occurred
        console.error(err);
        res.status(500).send("Error occurred while executing command");
      } else {
        // the entire stdout and stderr (buffered)
        console.log(`stdout: ${stdout}`);
        // console.log(`stderr: ${stderr}`);
        res.send(stdout);
      }
    });
  });

  app.get("/kindInit", (req, res) => {
    console.log("entered create_template");
    // check if cluster exists
    check_cluster();
    if (stdout === "Cluster exists") {
      console.log("cluster exists");
    } else {
      console.log("cluster does not exist");
      console.log("creating cluster");
      //how to run shell script from nodejs
      const { spawn } = require("child_process");
      const cmd = spawn("./network", ["kind"], { cwd: "../" });
      cmd.stdout.on("data", (data) => {
        console.log(`${data}`);
      });
      cmd.stderr.on("data", (data) => {
        console.error(`stderr: ${data}`);
      });
      cmd.on("close", (code) => {
        console.log(`child process exited with code ${code}`);

        // network cluster init
        const cmd2 = spawn("./network", ["cluster", "init"], { cwd: "../" });
        this.commom_emit(req, res, cmd2);
      });
    }
  });

  //fullscript.sh
  app.get("/defaultNetwork", (req, res) => {
    console.log("entered template");
    const child = exec("./fullscript.sh", { cwd: "../" });
    this.commom_emit(req, res, child);
  });

  // //create org
  // app.post("/createOrg",(req,res)=>{
  //   console.log("Creating org");
  //   try {
  //     const { org_name, namespace } = req.body;
  //     const child1 = exec(`export ORG_NAME=${org_name} && export NAMESPACE=${namespace}` ,{ cwd: "../"});
  //     const child = exec("./network1.sh up", { cwd: "../" });
  //     this.commom_emit(req, res, child1, child);
  //   } catch (error) {
  //     console.error(`Error parsing request body: ${error}`);
  //     res.status(400).send('Error parsing request body');
  //   }

  // });

  const { spawn } = require('child_process');
  const bodyParser = require('body-parser');

  //const app = express();
  app.use(bodyParser.json());


  app.post('/createOrg', async (req, res) => {
    console.log('Creating org');
    try {
      const { org_name, namespace } = req.body;
      const child1 = exec("./change.sh", {
        cwd: '../',
        env: {
          ...process.env,
          ORG_NAME: org_name,
          NAMESPACE: namespace
        }
      });
      this.commom_emit(req, res, child1);
      const child = spawn('./network1.sh', ['up'], {
        cwd: '../',
        env: {
          ...process.env,
          ORG_NAME: org_name,
          NAMESPACE: namespace
        }
      });
      child.stdout.on("data", (data) => {
        console.log(`${data}`);
      });
      child.stderr.on("data", (data) => {
        console.error(`stderr: ${data}`);
      });
      child.on("close", (code) => {
        console.log(`child process exited with code ${code}`);
        if (code === 0) {
          res.status(200).send('Organization created successfully');
        } else {
          res.status(500).send(`Error creating organization: ${code}`);
        }
      });
    } catch (error) {
      console.error(`Error parsing request body: ${error}`);
      res.status(400).send('Error parsing request body');
    }
  });
  
  


  app.get("/teardown_network", (req, res) => {
    const { spawn } = require("child_process");
    const cmd = spawn("./network", ["down"], { cwd: "../" });
    // res.setHeader("Connection", "keep-alive");
    this.commom_emit(req, res, cmd);
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

    cmd.stdout.on("data", (data) => {
      console.log(`stdout: ${data}`);
      res.write(data);
    });

    cmd.stderr.on("data", (data) => {
      console.error(`stderr: ${data}`);
      res.write(data);
    });

    cmd.on("close", (code) => {
      console.log(`child process exited with code ${code}`);
      res.end();
    });
  };

  // commom_emit = async (req, res, cmd1, cmd2) => {
  //   try {
  //     let data = "";
  //     cmd1.stdout.on("data", (chunk) => {
  //       data += chunk;
  //     });
  //     await new Promise((resolve, reject) => {
  //       cmd1.on("close", (code) => {
  //         console.log(`child process exited with code ${code}`);
  //         resolve();
  //       });
  //     });
  
  //     console.log("change.sh cmd executed");
  
  //     cmd2.stdout.on("data", (chunk) => {
  //       console.log(`stdout: ${chunk}`);
  //       data += chunk;
  //     });
  //     await new Promise((resolve, reject) => {
  //       cmd2.on("close", (code) => {
  //         console.log(`child process exited with code ${code}`);
  //         resolve();
  //       });
  //     });
  
  //     res.status(200).send(data);
  //   } catch (error) {
  //     console.error(`Error executing command: ${error}`);
  //     res.status(500).send(`Error executing command: ${error}`);
  //   }
  // };

  app.listen(port, () => {
    console.log("Server is listening");
  });
}

main();