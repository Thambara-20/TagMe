import { Router } from "express";
const router = Router();
import {
  getHello,
  getClubs,
  updateClubs,
} from "../controllers/clubController.js";

router.get("/", getHello);
router.get("/getclubs", getClubs);
router.post("/updateclubs", updateClubs);

export default router;
