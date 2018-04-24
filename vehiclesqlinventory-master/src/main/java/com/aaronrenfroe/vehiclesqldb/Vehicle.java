package com.aaronrenfroe.vehiclesqldb;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by AaronR on 11/4/17.
 * for ?
 */
@Entity
@Table(name="vehicles")
public class Vehicle implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    private String makeModel;
    private int year;
    private double retailPrice;


    public Vehicle(){ }

    public Vehicle(int id, String makeModel, int year, double retailPrice){
        this.id = id;
        this.makeModel = makeModel;
        this.year = year;
        this.retailPrice = retailPrice;
    }

    public double getRetailPrice() {
        return retailPrice;
    }

    public void setRetailPrice(double retailPrice) {
        this.retailPrice = retailPrice;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMakeModel() {
        return makeModel;
    }

    public void setMakeModel(String makeModel) {
        this.makeModel = makeModel;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    @Override
    public int hashCode() {
        return (int)( this.id * 37
                + this.year * 47
                + this.retailPrice * 109
                + this.makeModel.hashCode());
    }

    @Override
    public boolean equals(Object obj) {
        if(obj.getClass() == Vehicle.class){
            Vehicle v = (Vehicle) obj;
            boolean mmequal = false;

            if(v.makeModel != null & makeModel != null) {
                mmequal = v.makeModel.equals(makeModel);
            }else{
                mmequal = v.makeModel == makeModel;
            }

            return v.id == id & mmequal & v.retailPrice == retailPrice & v.year == year;

        }
        return false;
    }
}