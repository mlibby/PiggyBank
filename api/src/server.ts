import express, { Request, Response } from "express";
//import formidable from "express-formidable";

//import fs from "fs";
//import path from "path";

export class PiggyBankApi {

}



//app: express.Application;

// const Repo = require("./repo/PiggyBankRepo.js")
// const repo = new Repo()
// repo.updateDb()

//app = express();
//setupHttpServer();
//setupMainRoutes();
//setupApiRoutes(repo)

//const port = 3030;
//app.listen(port, () => {
//  console.log("server starting on port : " + port);
//});

//setupHttpServer() {

  // const https = require("https")

  // const keyPath = path.join(__dirname, "..", ".ssl", "selfsigned.key")
  // const key = fs.readFileSync(keyPath)
  // const certPath = path.join(__dirname, "..", ".ssl", "/selfsigned.crt")
  // const cert = fs.readFileSync(certPath)
  // const options = {
  //   key: key,
  //   cert: cert
  // }


  //const server = https.createServer(options, app)
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