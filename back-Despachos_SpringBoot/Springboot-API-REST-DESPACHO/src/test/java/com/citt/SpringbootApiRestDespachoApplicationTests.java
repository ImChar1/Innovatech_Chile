// Guardar como: back-Despachos_SpringBoot/Springboot-API-REST-DESPACHO/src/test/java/com/citt/SpringbootApiRestDespachoApplicationTests.java
package com.citt;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test") // Usa application-test.properties (H2) en vez de MySQL real
class SpringbootApiRestDespachoApplicationTests {

	@Test
	void contextLoads() {
	}

}