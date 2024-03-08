import { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";


export default function CreateProfesor() {
    const navigate = useNavigate();

    const [inputs, setInputs] = useState({ cedula: "", nombre: "", apellido: "" });
    const [error, setError] = useState("");

    const handleChange = (event) => {
        const { name, value } = event.target;
        setInputs(prevInputs => ({ ...prevInputs, [name]: value }));
    }

    const handleSubmit = (event) => {
        event.preventDefault();

        // Verificar si los campos requeridos están llenos
        if (!inputs.cedula || !inputs.nombre || !inputs.apellido) {
            setError("Por favor, complete todos los campos.");
            return;
        }

        // Convertir los datos del formulario a formato JSON
        const jsonData = JSON.stringify(inputs);

        axios.post('http://localhost/react/api/', jsonData)
            .then(function(response) {
                console.log(response.data);
                navigate('/');
            })
            .catch(function(error) {
                setError("Hubo un error al crear el profesor. Por favor, inténtelo de nuevo más tarde.");
                console.error("Error al crear el profesor:", error);
            });
    }

    return (
        <div className="row">
            <div className="col-2"></div>
            <div className="col-8">
                <h1>Crear Profesor</h1>
                {error && <div className="alert alert-danger">{error}</div>}
                <form onSubmit={handleSubmit}>
                    <div className="mb-3">
                        <label>Cédula</label>
                        <input type="text" className="form-control" name="cedula" value={inputs.cedula} onChange={handleChange} />
                    </div>
                    <div className="mb-3">
                        <label>Nombre</label>
                        <input type="text" className="form-control" name="nombre" value={inputs.nombre} onChange={handleChange} />
                    </div>
                    <div className="mb-3">
                        <label>Apellido</label>
                        <input type="text" className="form-control" name="apellido" value={inputs.apellido} onChange={handleChange} />
                    </div>
                    <button type="submit" className="btn btn-primary">Guardar 💾</button>
                </form>
            </div>
            <div className="col-2"></div>
        </div>
    )
}
