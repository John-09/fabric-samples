'use strict';

const { Contract } = require('fabric-contract-api');

class AssetTransfer extends Contract {

  async InitLedger(ctx) {
    const user = [
      {
        name: "adhavan",
        orgName: "Org1",
        id: "1",
        password: "73994812",
        type: "admin",
      },
      {
        name: "john",
        orgName: "Org2",
        id: "2",
        password: "1234",
        type: "admin",
      },
    ];

    for (const userDetails of user) {
      const userAsBytes = await ctx.stub.getState(userDetails.id);
      if (userAsBytes && userAsBytes.length > 0) {
        throw new Error(`User with ID ${userDetails.id} already exists`);
      }
      userDetails.docType = "userDetails";
      await ctx.stub.putState(
        userDetails.id,
        Buffer.from(JSON.stringify(userDetails))
      );
    }
  }

  async registerUser(ctx, name, orgName, id, password, type) {
    const userAsBytes = await ctx.stub.getState(id);
    if (userAsBytes && userAsBytes.length > 0) {
      throw new Error(`User with ID ${id} already exists`);
    }
    const user = {
      name,
      orgName,
      id,
      password,
      type,
    };
    await ctx.stub.putState(id, Buffer.from(JSON.stringify(user)));
  }

  async authenticateUser(ctx, id, password) {
    const userAsBytes = await ctx.stub.getState(id);
    if (!userAsBytes || userAsBytes.length === 0) {
      throw new Error(`User with ID ${id} does not exist`);
    }
    const user = JSON.parse(userAsBytes.toString());
    return user.password === password;
  }

  async queryUser(ctx, id) {
    const userAsBytes = await ctx.stub.getState(id);
    if (!userAsBytes || userAsBytes.length === 0) {
      throw new Error(`User with ID ${id} does not exist`);
    }
    const user = JSON.parse(userAsBytes.toString());
    return user;
  }

  async deleteUser(ctx, id) {
    const userAsBytes = await ctx.stub.getState(id);
    if (!userAsBytes || userAsBytes.length === 0) {
      throw new Error(`User with ID ${id} does not exist`);
    }
    await ctx.stub.deleteState(id);
  }

  async updateUser(ctx, id, name, orgName, password, type) {
    const userAsBytes = await ctx.stub.getState(id);
    if (!userAsBytes || userAsBytes.length === 0) {
      throw new Error(`User with ID ${id} does not exist`);
    }
    const user = JSON.parse(userAsBytes.toString());
    if (name) {
      user.name = name;
    }
    if (orgName) {
      user.orgName = orgName;
    }
    if (password) {
      user.password = password;
    }
    if (type) {
      user.type = type;
    }
    await ctx.stub.putState(id, Buffer.from(JSON.stringify(user)));
  }
}

module.exports = AssetTransfer;
