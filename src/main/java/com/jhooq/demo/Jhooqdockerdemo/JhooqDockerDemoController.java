package com.jhooq.demo.Jhooqdockerdemo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class JhooqDockerDemoController {
    @GetMapping("/")
    public String hello() {
        return "Hello - Docker";
    }
}
