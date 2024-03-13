import { collection, getDocs } from "firebase/firestore";
import { db } from "../auth.js";

const fetchEvents = async () => {
  try {
    const eventsCollection = collection(db, "events");
    const querySnapshot = await getDocs(eventsCollection);

    const eventsList = [];

    querySnapshot.forEach((doc) => {
      const data = doc.data();
      eventsList.push({
        id: doc.id,
        coordinates: data.coordinates,
        creator: data.creator,
        district: data.district,
        endTime: data.endTime.toDate(),
        isParticipating: data.isParticipating,
        location: data.location,
        name: data.name,
        participants: data.participants,
        startTime: data.startTime.toDate(),
      });
    });

    console.log("Fetched Events:", eventsList);

    return eventsList;
  } catch (error) {
    console.error("Error fetching events: ", error);
    return [];
  }
};

const prospectData = async (uid) => {
  try {
    const prospectsCollection = collection(db, "prospects");
    const querySnapshot = await getDocs(prospectsCollection);
    const prospectData = [];

    querySnapshot.forEach((doc) => {
      const data = doc.data();
      if (data.uid === uid) {
        prospectData.push({
          id: doc.id,
          designation: null,
          district: data.district,
          name: data.name,
          userClub: data.userClub,
        });
      }
    });

    console.log("Fetched ProspectData:", prospectData);
    return prospectData;
  } catch (error) {
    console.error("Error fetching prospects: ", error);
    return [];
  }
};

const memberData = async (uid) => {
  try {
    const memberCollection = collection(db, "members");
    const querySnapshot = await getDocs(memberCollection);
    const memberData = [];

    querySnapshot.forEach((doc) => {
      const data = doc.data();
      if (data.uid === uid) {
        memberData.push({
          id: doc.id,
          designation: data.designation,
          district: data.district,
          name: data.name,
          userClub: data.userClub,
        });
      }
    });
    return memberData;
  } catch (error) {
    console.error("Error fetching member data: ", error);
    return [];
  }
};

export { fetchEvents, prospectData, memberData };
