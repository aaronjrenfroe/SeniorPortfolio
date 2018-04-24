package com.aaronrenfroe.vehiclesqldb;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

import java.util.List;

/**
 * Created by AaronR on 11/19/17.
 * for ?
 */
@RestController
public class InventoryController {

    @Autowired
    VehicleDAO vDAO;

    @RequestMapping(value = "/addVehicle", method = RequestMethod.POST)
    public Vehicle addVehicle(@RequestBody Vehicle vehicle) throws IOException {
        if(vehicle.getMakeModel() != null){
            vDAO.create(vehicle);
            return vDAO.getById(vehicle.getId());
        }else{
            return null;
        }
    }

    @RequestMapping(value = "/getVehicle/{id}", method = RequestMethod.GET)
    public Vehicle getVehicle(@PathVariable("id") int id) throws IOException {
        return vDAO.getById(id);
    }

    @RequestMapping(value = "/updateVehicle", method = RequestMethod.PUT)
    public Vehicle updateVehicle(@RequestBody Vehicle vehicle) throws IOException {

        if (vDAO.updateVehicle(vehicle)) {
            // vehicle was found in the db and updated;
            return vDAO.getById(vehicle.getId());
        }else{
            // vehicle was not found and no changes were made
            return null;
        }

    }

    @RequestMapping(value = "/deleteVehicle/{id}", method = RequestMethod.DELETE)
    public ResponseEntity<String> deleteVehicle(@PathVariable("id") int id) throws IOException {

        HttpHeaders responseHeaders = new HttpHeaders();

        // checks if db contains vehicle with id
        Vehicle v = vDAO.getById(id);
        if (v!=null){
            // if yes remove and return Found
            vDAO.delete(v);
            return new ResponseEntity("Deleted Vehicle With ID: " + id, responseHeaders, HttpStatus.FOUND);
        }else {
            // else return not Accepted
            return new ResponseEntity("ID Not Found:" + id, responseHeaders, HttpStatus.NOT_FOUND);
        }

    }

    @RequestMapping(value = "/getLatestVehicles", method = RequestMethod.GET)
    public List<Vehicle> getLatestVehicle() throws IOException {
        return vDAO.getLast10();
    }
}
