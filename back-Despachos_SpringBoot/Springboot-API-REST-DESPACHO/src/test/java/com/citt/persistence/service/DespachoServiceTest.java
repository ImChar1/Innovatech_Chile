// Guardar como: back-Despachos_SpringBoot/Springboot-API-REST-DESPACHO/src/test/java/com/citt/persistence/service/DespachoServiceTest.java
package com.citt.persistence.service;

import com.citt.exceptions.DespachoNotFoundException;
import com.citt.persistence.entity.Despacho;
import com.citt.persistence.repository.DespachoRepository;
import com.citt.persistence.services.DespachoServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class DespachoServiceTest {

    @Mock
    private DespachoRepository despachoRepository;

    @InjectMocks
    private DespachoServiceImpl despachoService;

    private Despacho despacho;

    @BeforeEach
    public void setUp() {
        despacho = new Despacho();
        despacho.setIdDespacho(1L);
        despacho.setFechaDespacho(LocalDate.of(2025, 4, 14));
        despacho.setPatenteCamion("ABCD-12");
        despacho.setIntento(1);
        despacho.setIdCompra(100L);
        despacho.setDireccionCompra("Calle Falsa 123");
        despacho.setValorCompra(1000L);
        despacho.setDespachado(false);
    }

    @Test
    @DisplayName("Cuando se guarda un despacho válido, entonces se persiste correctamente")
    public void whenSavingValidDespacho_thenItIsPersistedCorrectly() {
        when(despachoRepository.save(any(Despacho.class))).thenReturn(despacho);

        Despacho savedDespacho = despachoService.saveDespacho(despacho);

        verify(despachoRepository, times(1)).save(despacho);
        assertNotNull(savedDespacho);
        assertEquals(despacho.getDireccionCompra(), savedDespacho.getDireccionCompra());
        assertEquals(despacho.getPatenteCamion(), savedDespacho.getPatenteCamion());
        assertEquals(despacho.getValorCompra(), savedDespacho.getValorCompra());
        assertEquals(despacho.isDespachado(), savedDespacho.isDespachado());
    }

    @Test
    @DisplayName("Cuando se listan todos los despachos, entonces se retorna la lista completa")
    public void whenFindingAllDespachos_thenReturnsAllDespachos() {
        Despacho otroDespacho = new Despacho();
        otroDespacho.setIdDespacho(2L);
        otroDespacho.setPatenteCamion("EFGH-34");

        when(despachoRepository.findAll()).thenReturn(Arrays.asList(despacho, otroDespacho));

        List<Despacho> result = despachoService.findAllDespachos();

        verify(despachoRepository, times(1)).findAll();
        assertNotNull(result);
        assertEquals(2, result.size());
    }

    @Test
    @DisplayName("Cuando se busca un despacho existente por ID, entonces se retorna correctamente")
    public void whenFindingExistingDespachoById_thenReturnsDespacho() throws DespachoNotFoundException {
        when(despachoRepository.findById(1L)).thenReturn(Optional.of(despacho));

        Despacho result = despachoService.findById(1L);

        assertNotNull(result);
        assertEquals(despacho.getIdDespacho(), result.getIdDespacho());
    }

    @Test
    @DisplayName("Cuando se busca un despacho inexistente por ID, entonces se lanza excepción")
    public void whenFindingNonExistentDespachoById_thenThrowsException() {
        when(despachoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(DespachoNotFoundException.class, () -> despachoService.findById(99L));
    }

    @Test
    @DisplayName("Cuando se actualiza un despacho existente, entonces se guardan los nuevos valores")
    public void whenUpdatingExistingDespacho_thenFieldsAreUpdated() throws DespachoNotFoundException {
        Despacho datosActualizados = new Despacho();
        datosActualizados.setFechaDespacho(LocalDate.of(2025, 5, 1));
        datosActualizados.setPatenteCamion("ZZZZ-99");
        datosActualizados.setIntento(2);
        datosActualizados.setIdCompra(200L);
        datosActualizados.setDireccionCompra("Nueva Direccion 456");
        datosActualizados.setValorCompra(2000L);
        datosActualizados.setDespachado(true);

        when(despachoRepository.findById(1L)).thenReturn(Optional.of(despacho));
        when(despachoRepository.save(any(Despacho.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Despacho result = despachoService.updateDespacho(1L, datosActualizados);

        assertNotNull(result);
        assertEquals("ZZZZ-99", result.getPatenteCamion());
        assertEquals("Nueva Direccion 456", result.getDireccionCompra());
        assertTrue(result.isDespachado());
        verify(despachoRepository, times(1)).save(any(Despacho.class));
    }

    @Test
    @DisplayName("Cuando se actualiza un despacho inexistente, entonces se lanza excepción")
    public void whenUpdatingNonExistentDespacho_thenThrowsException() {
        when(despachoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(DespachoNotFoundException.class,
                () -> despachoService.updateDespacho(99L, despacho));

        verify(despachoRepository, never()).save(any(Despacho.class));
    }

    @Test
    @DisplayName("Cuando se elimina un despacho existente, entonces se llama al repositorio")
    public void whenDeletingExistingDespacho_thenRepositoryDeleteIsCalled() throws DespachoNotFoundException {
        when(despachoRepository.findById(1L)).thenReturn(Optional.of(despacho));

        despachoService.deleteDespacho(1L);

        verify(despachoRepository, times(1)).deleteById(1L);
    }

    @Test
    @DisplayName("Cuando se elimina un despacho inexistente, entonces se lanza excepción")
    public void whenDeletingNonExistentDespacho_thenThrowsException() {
        when(despachoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(DespachoNotFoundException.class, () -> despachoService.deleteDespacho(99L));

        verify(despachoRepository, never()).deleteById(anyLong());
    }
}