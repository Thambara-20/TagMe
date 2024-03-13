import { collection, getDocs } from "firebase/firestore";
import { db } from "../auth.js";

const fetchEvents = async () => {
  try {
    const eventsCollection = collection(db, 'events');
    const querySnapshot = await getDocs(eventsCollection);
    
    const eventsList = [];
    
    querySnapshot.forEach(doc => {
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
        participants: data.participants.length,
        startTime: data.startTime.toDate()
      });
    });

    console.log('Fetched Events:', eventsList);
    
    return eventsList; 
  } catch (error) {
    console.error('Error fetching events: ', error);
    return []; 
  }
};


export { fetchEvents };
