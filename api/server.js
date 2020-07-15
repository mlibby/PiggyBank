const express = require("express");
const formidable = require("express-formidable");
const PiggyBankRepo = require("./repo/PiggyBankRepo");

//import fs from "fs";
//import path from "path";

class PiggyBankApi {
  constructor(app, repo, formHandler = formidable(), port = 3030) {
    this.app = app;
    this.port = port;
    this.repo = repo;
    this.formHandler = formHandler;
  }

  start() {
    this.setupHttpServer();
    this.repo.updateDb();
    this.app.listen(this.port, () => {
      /* istanbul ignore next */
      console.log(`server starting on port: ${this.port}`);
    });
  }

  setupHttpServer() {
    // const keyPath = path.join(__dirname, "..", ".ssl", "selfsigned.key")
    // const key = fs.readFileSync(keyPath)
    // const certPath = path.join(__dirname, "..", ".ssl", "/selfsigned.crt")
    // const cert = fs.readFileSync(certPath)
    // const options = {
    //   key: key,
    //   cert: cert
    // }
    //const server = https.createServer(options, app)
    this.app.use(this.formHandler);
  }
}

/* istanbul ignore if */
if (require.main === module) {
  const repo = new PiggyBankRepo(new pg.Pool({
    database: "piggybank",
    user: "pb_user",
    password: "piggybank"
  }));

  // const https = require("https")
  const api = new PiggyBankApi(express(), repo);
  api.start();
}

module.exports = PiggyBankApi;
//setupMainRoutes();
//setupApiRoutes(repo)

//setupHttpServer() {

//  app.use(formidable())
//}

//function skipIndex(req: Request) {
//  return ["/api/"].some((fragment) => {
//   return req.url.substr(0, fragment.length) === fragment
//  })
//}

//function setupMainRoutes() {
//  app.get("/", (req: Request, res: Response) => {
//    res.send("Hello World!");
//  });

  //app.use(express.static(path.join(__dirname, "..", "www-client")))

  // app.use(function (req, res, next) {
  //   if (skipIndex(req)) {
  //     return next()
  //   }

    //   console.log(`Request for ${req.path} (not api or static)`)
    //   res.sendFile(`${__dirname}/index.html`)
    // })
//  })
//}

// function setupApiRoutes(repo) {
//   const AccountApi = require("./api/AccountApi")
//   const accountApi = new AccountApi(express.Router(), repo)
//   app.use("/api/account", accountApi.router)

//   const ApiKeyApi = require("./api/ApiKeyApi")
//   const apiKeyApi = new ApiKeyApi(express.Router(), repo)
//   app.use("/api/apiKey", apiKeyApi.router)

//   const CommodityApi = require("./api/CommodityApi")
//   const commodityApi = new CommodityApi(express.Router(), repo)
//   app.use("/api/commodity", commodityApi.router)

//   const OfxApi = require("./api/OfxApi")
//   const ofxApi = new OfxApi(express.Router(), repo)
//   app.use("/api/ofx", ofxApi.router)

//   const PriceApi = require("./api/PriceApi")
//   const priceApi = new PriceApi(express.Router(), repo)
//   app.use("/api/price", priceApi.router)

//   const TxApi = require("./api/TxApi")
//   const txApi = new TxApi(express.Router(), repo)
//   app.use("/api/tx", txApi.router)
// }