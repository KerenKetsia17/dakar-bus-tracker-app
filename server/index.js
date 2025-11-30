
const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');

// --- Firebase Admin SDK Initialization ---
try {
  const serviceAccount = require('./serviceAccountKey.json');
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'https://dakar-bus-tracker-app.firebaseio.com'
  });
} catch (error) {
  console.error('Erreur: Le fichier serviceAccountKey.json est manquant ou invalide.');
  console.error('Veuillez le télécharger depuis votre console Firebase et le placer dans le répertoire /server.');
  process.exit(1);
}

const db = admin.database();
const app = express();
app.use(express.json());
app.use(cors());

const PORT = process.env.PORT || 3001; // <-- Port changé à 3001

// --- Helper Functions ---
const handleError = (res, error, message = 'Une erreur est survenue sur le serveur.') => {
  console.error(error);
  res.status(500).json({ error: message, details: error.message });
};

// --- API Routes for LIGNES ---
app.get('/api/lignes', async (req, res) => {
  try {
    const snapshot = await db.ref('lignes').once('value');
    const data = snapshot.val();
    if (!data) return res.status(200).json([]);
    const lignes = Object.keys(data).map(key => ({ idLigne: key, ...data[key] }));
    res.status(200).json(lignes);
  } catch (error) {
    handleError(res, error);
  }
});

app.post('/api/lignes', async (req, res) => {
  try {
    const { numero, depart, destination, frequence, color, routePoints } = req.body;
    const newLigneRef = db.ref('lignes').push();
    const nouvelleLigne = { numero, depart, destination, frequence, color, routePoints: routePoints || [] };
    await newLigneRef.set(nouvelleLigne);
    res.status(201).json({ idLigne: newLigneRef.key, ...nouvelleLigne });
  } catch (error) {
    handleError(res, error);
  }
});

app.put('/api/lignes/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const updatedData = req.body;
    await db.ref(`lignes/${id}`).update(updatedData);
    res.status(200).json({ message: 'Ligne mise à jour avec succès', id, ...updatedData });
  } catch (error) {
    handleError(res, error);
  }
});

app.delete('/api/lignes/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await db.ref(`lignes/${id}`).remove();
    res.status(200).json({ message: 'Ligne supprimée avec succès' });
  } catch (error) {
    handleError(res, error);
  }
});

// TODO: Add routes for Bus, Incidents, and Utilisateurs

// --- Start Server ---
app.listen(PORT, () => {
  console.log(`Le serveur backend écoute sur le port ${PORT}`);
});
