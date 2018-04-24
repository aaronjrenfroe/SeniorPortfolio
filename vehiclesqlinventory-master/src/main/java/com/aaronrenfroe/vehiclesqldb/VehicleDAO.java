package com.aaronrenfroe.vehiclesqldb;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import java.util.List;

/**
 * Created by AaronR on 11/19/17.
 * for ?
 */
@Repository
@Transactional
public class VehicleDAO {

    @PersistenceContext
    private EntityManager em;

    public void create(Vehicle vehicle){
        em.persist(vehicle);
    }

    public Vehicle getById(int id){ return em.find(Vehicle.class, id); }

    public boolean updateVehicle(Vehicle vehicle){
        // updates persisted object overwriting any changes
        Vehicle v = getById(vehicle.getId());
        if (v != null) {
            em.merge(vehicle);
            return true;
        }else{
            return false;
        }

    }

    public boolean delete(Vehicle vehicle){
        // updates persisted object overwriting any changes
        if (em.contains(vehicle)) {
            em.remove(vehicle);
            return true;
        }else{
            return false;
        }

    }

    public List<Vehicle> getLast10(){
        Query query = em.createNativeQuery("SELECT * FROM vehicles v order by v.id desc");
        query.setMaxResults(10);
        return query.getResultList();
    }

}
