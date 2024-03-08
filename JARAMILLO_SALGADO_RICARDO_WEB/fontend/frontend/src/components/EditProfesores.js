import { useState, useEffect } from "react";
import axios from "axios";
import { useNavigate, useParams } from "react-router-dom";
 
export default function ListProfesores() {
    const navigate = useNavigate();
    const { id } = useParams();
 
    const [inputs, setInputs] = useState({});
 
    useEffect(() => {
        getProfesor();
    }, []);
 
    function getProfesor() {
        axios.get(`http://localhost/react/api/${id}`).then(function(response) {
            console.log(response.data);
            setInputs(response.data);
        });
    }
 
    const handleChange = (event) => {
        const { name, value } = event.target;
        setInputs(values => ({...values, [name]: value}));
    }
    
    const handleSubmit = (event) => {
        event.preventDefault();
 
        axios.put(`http://localhost/react/api/${id}/edit`, inputs).then(function(response){
            console.log(response.data);
            navigate('/');
        });
    }
    
    return (
        <div className="row">
            <div className="col-2"></div>
            <div className="col-8">
                <h1>Editar Profesor</h1>
                <form onSubmit={handleSubmit}>
                    <div className="mb-3">
                        <label>Cédula</label>
                        <input type="text" value={inputs.cedula} className="form-control" name="cedula" onChange={handleChange} />
                    </div>
                    <div className="mb-3">
                        <label>Nombre</label>
                        <input type="text" value={inputs.nombre} className="form-control" name="nombre" onChange={handleChange} />
                    </div>
                    <div className="mb-3">
                        <label>Apellido</label>
                        <input type="text" value={inputs.apellido} className="form-control" name="apellido" onChange={handleChange} />
                    </div>    
                    <button type="submit" name="update" className="btn btn-primary">Guardar 💾</button>
                </form>
            </div>
            <div className="col-2"></div>
        </div>
    )
}
