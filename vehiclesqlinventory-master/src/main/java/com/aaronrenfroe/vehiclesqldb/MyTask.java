package com.aaronrenfroe.vehiclesqldb;


import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;


@Component
public class MyTask {

    RestTemplate rT = new RestTemplate();

    @Scheduled(cron = "0 * * * * *")
    private void addVehicle(){

        Vehicle v = getRandomVehicle();
        String url = "http://localhost:8080/addVehicle";
        rT.postForEntity(url, v, Vehicle.class);

    }

    @Scheduled(cron = "0 * * * * *")
    private void deleteVehicle(){

        int id = (int) (Math.random()*100);
        String url = "http://localhost:8080/deleteVehicle/" + id;
        rT.delete(url);

    }

    @Scheduled(cron = "0 0 * * * *") // Top of the hour
    private void getVehicle(){

        int id = (int) (Math.random()*100);
        String url = "http://localhost:8080/getVehicle/" + id;
        Vehicle v = rT.getForEntity(url, Vehicle.class).getBody();
    }

    @Scheduled(cron = "0 * * * * *")
    private void updateVehicle(){

        int id = (int) (Math.random()*101);
        Vehicle v = getRandomVehicle();
        String url = "http://localhost:8080/updateVehicle";
        rT.put(url, v);
        url = "http://localhost:8080/getVehicle/" + id;
        v = rT.getForEntity(url,Vehicle.class).getBody();
        System.out.println(v);
    }

    @Scheduled(cron = "0 0 * * * *") // Top of the hour
    private void latestVehiclesReport()throws IOException{
        String url = "http://localhost:8080/getLatestVehicles";
        Object[] vList =  rT.getForEntity(url,Object[].class).getBody();

        for (int i = 0; i < vList.length; i++) {

            System.out.println(vList[i].toString());
        }
    }

    private Vehicle getRandomVehicle(){

        int year = ((int) (Math.random() * (2016-1986))) + 1986;
        double retailPrice = ((int)((Math.random()*(45000-15000))) /1) + 15000;
        String make = "RAND-M&M"+ RandomStringUtils.randomAlphabetic((int) (Math.random()*10) + 2);

        return new Vehicle(0,make,year,retailPrice);

    }
}
