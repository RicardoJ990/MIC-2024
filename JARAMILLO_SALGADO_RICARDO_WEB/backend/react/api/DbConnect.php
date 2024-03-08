<?php
    class DbConnect {
        private $server = 'localhost'; //Definimos una propiedad privada para almacenar la dirección del servidor MySQL
        private $dbname = 'colegio'; //Definimos una propiedad privada para almacenar el nombre de la base de datos
        private $user = 'root'; //Definimos una propiedad privada para almacenar el usuario MySQL
        private $pass = 'root'; //Seguidamente de la contraseña
 
        public function connect() { //definimos una nueva clase llamada DbConnect
            try {
                $conn = new PDO('mysql:host=' .$this->server .';dbname=' . $this->dbname, $this->user, $this->pass); //Creamos
                return $conn;
            } catch (\Exception $e) { //Comienza un bloque catch para manejar cualquier excepción que pueda generarse
                echo "Error en la conexión a la BDD: " . $e->getMessage();
            }
        }
         
    }
?>