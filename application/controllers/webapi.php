<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Webapi extends CI_Controller {

	function __construct() {  
        parent::__construct();
       
        $this->load->model('customer_model', '', TRUE);
       
        ini_set('memory_limit', '-1');
        ini_set('display_errors', 1);
        error_reporting(E_ALL);
        $this->load->library('email');
        $this->load->library('upload');
        $this->load->helper('url');
        ini_set('memory_limit', '-1');
    }
	function index() { 
      // echo 'dfsdfs';exit;
        error_reporting(E_ALL);
		header('Access-Control-Allow-Origin: *');
		header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
		header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
        header('Content-type: application/json');
        $data = file_get_contents('php://input');
		
        
        if ($data == null) {
            //$data = '{"method":"registerUserDetails","body":{"UserName":"sanju","Password":"passs","Email":"test@test.com","FirstName":"sanjay","LastName":"Kuamr","date":"25/05/2015"}}';
            //$data = '{"method":"getVendorsList","body":{}}';
        }
		$data = utf8_encode($data);
		$data = $this->checkvalidjson($data);
        $method = $data->method;
        $json = $data->body;
	
		switch ($method) {
            case 'registerUserDetails':
                $this->registerUser($json);
                break;
            case 'getVendorsList':
                $this->getVendors();
                break;
			case 'Login':
                $this->checkLogin($json);
                break;
            default:
			    $this->test();
                break;
        }
        
	
}
    function checkvalidjson($json) {
        $obj = json_decode(stripslashes($json), TRUE);
        if (is_null($obj)) {
            $response['error'] = 1;
            $response['data'] = "Invalid Json format";
            echo json_encode($response);
            exit();
        } else {
            $data = json_decode($json);
            return $data;
        }
    }
     function test() {
        $response = array();
        $response['Account']['Error'] = 1;
        $response['Account']['Message'] = 'You do not enter method.';
        echo json_encode($response);
        exit();
    }
   
	function registerUser($data) {
        $response = array();
        $add_user = $this->customer_model->addProfile(
                $data->UserName, $data->Password, $data->Email, $data->FirstName, $data->LastName, $data->date);
        if (isset($add_user[0]->Status) && $add_user[0]->Status > 0) {
            $response['registerUser']['Error'] = 0;
            $response['registerUser']['Message'] = 'Add profile Successfully.';
            $response['registerUser']['data']['userId'] = $add_user[0]->Status;
        } else {
            $response['registerUser']['Error'] = 1;
            $response['registerUser']['Message'] = 'Add profile not done.';
        }
        echo json_encode($response);
        exit();
    }
        function getVendors() {

        $vendor_list = $this->customer_model->getvendors();
        $response['getVendors']['Error'] = 0;
        $response['getVendors']['data'] = $vendor_list;
        echo json_encode($response);
        exit();
    }
	function checkLogin($data) {
        $response = array();
        if ($data->Email == '') {
            $response['checkLogin']['Error'] = 1;
            $response['checkLogin']['Message'] = 'Email not found';
        } else if ($data->Password == '') {
            $response['checkLogin']['Error'] = 1;
            $response['checkLogin']['Message'] = 'Password not found';
        } else {
            $user_details = $this->customer_model->checkLogin($data->Email, $data->Password);

            if ($user_details == 'User not found') {
                $response['checkLogin']['Error'] = 1;
                $response['checkLogin']['Message'] = 'Invalid Login';
            } else if ($user_details > 0) {
                $response['checkLogin']['Error'] = 0;
                $response['checkLogin']['Message'] = 'Login Successful.';
                $response['checkLogin']['data'] = $user_details;
            }
        }
        echo json_encode($response);
        exit();
    }
}