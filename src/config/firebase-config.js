import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
// import { getAnalytics } from 'firebase/analytics';

const firebaseConfig = {
  apiKey: 'AIzaSyBRBkEZdZx9M-4jytmS3piVe7iHMdlhmkI',
  authDomain: 'orbital2223.firebaseapp.com',
  projectId: 'orbital2223',
  storageBucket: 'orbital2223.appspot.com',
  messagingSenderId: '66531394561',
  appId: '1:66531394561:web:f6f2cc311d91265345ec00',
  measurementId: 'G-CDQCRQ7S59',
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
// const analytics = getAnalytics(app);

export default auth;
