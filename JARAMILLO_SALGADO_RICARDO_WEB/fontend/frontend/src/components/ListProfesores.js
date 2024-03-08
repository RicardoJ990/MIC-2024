import axios from "axios" 
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";

export default function ListProfesores() {

    const [profesores, setProfesores] = useState([]);
    const [profesorSeleccionado, setProfesorSeleccionado] = useState(null);

    useEffect(() => {
        getProfesores();
    }, []);

    function getProfesores() {
        axios.get('http://localhost/react/api/').then(function(response) {
            console.log(response.data);
            setProfesores(response.data);
        });
    }

    const confirmarEliminar = (id_profesores) => {
        setProfesorSeleccionado(id_profesores);
    }

    const eliminarProfesor = () => {
        axios.delete(`http://localhost/react/api/${profesorSeleccionado}/delete`).then(function(response){
            console.log(response.data);
            getProfesores();
            setProfesorSeleccionado(null); // Reinicia el estado después de eliminar
        });
    }

    return (
        <div className="row">
            <div className="col-12">
            <h1>Listado de Profesores</h1>
            <table className="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Cédula</th>
                        <th>Nombre</th>
                        <th>Apellido</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    {profesores.map((profesor, key) =>
                        <tr key={key}>
                            <td>{profesor.id_profesores}</td>
                            <td>{profesor.cedula}</td>
                            <td>{profesor.nombre}</td>
                            <td>{profesor.apellido}</td>
                            <td>
                                <Link to={`profesores/${profesor.id_profesores}/edit`} className="btn btn-success" style={{marginRight: "10px"}}>Editar 🖊️</Link>
                                <button onClick={() => confirmarEliminar(profesor.id_profesores)} className="btn btn-danger">Eliminar ✖️</button>
                            </td>
                        </tr>
                    )}
                     
                </tbody>
            </table>

            {/* Modal de confirmación */}
            {profesorSeleccionado && 
                <div className="modal fade show" tabIndex="-1" role="dialog" style={{display: "block"}}>
                    <div className="modal-dialog" role="document">
                        <div className="modal-content">
                            <div className="modal-header">
                                <h5 className="modal-title">Confirmar eliminación</h5>
                                <button type="button" className="close" onClick={() => setProfesorSeleccionado(null)} aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div className="modal-body">
                                ¿Estás seguro de que deseas eliminar este profesor?
                            </div>
                            <div className="modal-footer">
                                <button type="button" className="btn btn-secondary" onClick={() => setProfesorSeleccionado(null)}>Cancelar</button>
                                <button type="button" className="btn btn-danger" onClick={eliminarProfesor}>Eliminar</button>
                            </div>
                        </div>
                    </div>
                </div>
            }
            </div>
        </div>
    )
}
