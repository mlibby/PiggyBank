const path = require("path")
const express = require("express")
const formidable = require("express-formidable")

const PiggyBankApi = exports.PiggyBankApi = class PiggyBankApi {
  constructor(repo, port) {
    this.repo = repo
    this.port = port

    this.app = express()

    this.wwwDir = path.join(__dirname, "..", "www")

    this.setupHttpServer()
    this.setupMainRoutes()
    this.setupApiRoutes()
  }

  async start() {
    this.repo.updateDb()
    this.app.listen(this.port,
      /* istanbul ignore next */
      () => {
        console.log(`server starting on port: ${this.port}`)
      })
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
    this.app.use(formidable())
  }

  skipIndex(req) {
    // right now we're only testing if the path starts with
    // "/api", but we can add to the list if we have other
    // patterns that we want to exclude
    return ["/api/"].some((fragment) => {
      return req.url.substr(0, fragment.length) === fragment
    })
  }

  sendIndex(req, res, next) {
    if (this.skipIndex(req)) {
      return next()
    }
    else {
      res.sendFile(path.join(this.wwwDir, "index.html"))
    }
  }

  setupMainRoutes() {
    this.app.use(this.express.static(this.wwwDir))
    this.app.use(this.sendIndex.bind(this))
  }

  setupApiRoutes() {
    const { AccountRoutes } = require("./routes/AccountRoutes")
    const accountRoutes = new AccountRoutes(this.express.Router(), this.repo)
    this.app.use("/api/account", accountRoutes.router)

    const { ApiKeyRoutes } = require("./routes/ApiKeyRoutes")
    const apiKeyRoutes = new ApiKeyRoutes(this.express.Router(), this.repo)
    this.app.use("/api/apikey", apiKeyRoutes.router)

    const { CommodityRoutes } = require("./routes/CommodityRoutes")
    const commodityRoutes = new CommodityRoutes(this.express.Router(), this.repo)
    this.app.use("/api/commodity", commodityRoutes.router)

    const { OfxRoutes } = require("./routes/OfxRoutes")
    const ofxRoutes = new OfxRoutes(this.express.Router(), this.repo)
    this.app.use("/api/ofx", ofxRoutes.router)

    const { PriceRoutes } = require("./routes/PriceRoutes")
    const priceRoutes = new PriceRoutes(this.express.Router(), this.repo)
    this.app.use("/api/price", priceRoutes.router)

    const { TxRoutes } = require("./routes/TxRoutes")
    const txRoutes = new TxRoutes(this.express.Router(), this.repo)
    this.app.use("/api/tx", txRoutes.router)
  }
}

/* istanbul ignore if */
if (require.main === module) {
  const { PiggyBankRepo } = require("./repo/PiggyBankRepo")
  const repo = new PiggyBankRepo()
  // const https = require("https");
  const api = new PiggyBankApi(repo, 3030)
  api.start()
}
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