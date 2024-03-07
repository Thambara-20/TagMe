import { collection, getDocs, doc, updateDoc } from "firebase/firestore";
import { db } from "../auth.js";

export function getHello(req, res) {
  res.send("Hello, this is your Express server!");
}

export async function getClubs(req, res) {
  try {
    const clubsRef = collection(db, "clubs");
    const querySnapshot = await getDocs(clubsRef);

    const clubs = {};
    querySnapshot.forEach((doc) => {
      clubs[doc.id] = doc.data();
    });

    // console.log(clubs);
    res.json(clubs);
  } catch (error) {
    console.error("Error fetching clubs:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
}

export async function updateClubs(req, res) {
  try {
    const { documentId, newClubs } = req.body;

    const clubDocRef = doc(db, "clubs", documentId);
    await updateDoc(clubDocRef, { clubs: newClubs });

    res.json({ message: `Clubs updated for document ${documentId}` });
  } catch (error) {
    console.error("Error updating clubs:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
}


