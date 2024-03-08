import {BrowserRouter, Routes, Route, Link} from 'react-router-dom'; 
import './App.css';
import CreateProfesores from './components/CreateProfesores';
import EditProfesores from './components/EditProfesores';
import ListProfesores from './components/ListProfesores';
 
function App() {
  return (
    <div className="container">
    <div className="App">
      <h1 class="page-header text-center">RICARDO ALEJANDRO JARAMILLO SALGADO - MIC 2024 🔗🏛️</h1>
 
      <BrowserRouter>
        <Link to="profesores/create" className="btn btn-success">Agregar un nuevo Profesor ✔️</Link>
 
        <Routes>
          <Route index element={<ListProfesores />} />
          <Route path="profesores/create" element={<CreateProfesores />} />
          <Route path="profesores/:id/edit" element={<EditProfesores />} />
        </Routes>
      </BrowserRouter>
    </div>
    </div>
  );
}
 
export default App;