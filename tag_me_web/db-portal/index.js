import express from "express";
import bodyParser from "body-parser";
import sampleRoutes from "./routes/routes.js";

const app = express();
const port = process.env.PORT || 5000;

app.use(bodyParser.json());

app.use("/db-portal", sampleRoutes);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
