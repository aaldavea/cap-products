const cds = require("@sap/cds");
const cors = require("cors");
const adapterProxy = require("@sap/cds-odata-v2-adapter-proxy");
const cds_swagger = require("cds-swagger-ui-express");

cds.on("bootstrap", (app) => {
    app.use(adapterProxy());
    app.use(cors());
    app.use(cds_swagger())
    app.get("/alive", (_, res) => {
        res.status(200).send("Server is Alive");
    });
});

// if (process.env.NODE_ENV !== "production") {
// const cds_swagger = require("cds-swagger-ui-express");
// cds.on('bootstrap', app =>
//     app.use(cds_swagger())
// )
// require("dotenv").config();
// }

module.exports = cds.server;