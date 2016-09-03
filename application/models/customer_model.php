<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class customer_model extends CI_Model {

    function __construct() {
        parent::__construct();
    }

   

   
    function addProfile($UserName, $Password, $Email, $FirstName, $LastName, $date) {
        $sql = "call usp_registerUser('" . $UserName . "','" . $Password . "','" . $Email . "','" . $FirstName . "','" . $LastName . "','" . $date . "')";
        $parameters = array();
        $query = $this->db->query($sql, $parameters);
        return $query->result();
    }
    public function checkLogin($email_id, $password) {

        $sql = "call usp_CheckLogin('" . $email_id . "','" . $password . "')";
        $parameters = array();
        $query = $this->db->query($sql, $parameters);
        return $query->result();
    }
	public function getvendors() {
        $sql = "call usp_GetVendors()";
        $parameters = array();
        $query = $this->db->query($sql, $parameters);
        return $query->result();
    }
   
    
}
