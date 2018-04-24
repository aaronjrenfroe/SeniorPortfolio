package com.aaronrenfroe.vehiclesqldb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class VehiclesqldbApplication {

	public static void main(String[] args) {
		SpringApplication.run(VehiclesqldbApplication.class, args);
	}
}
