package com.jeueducatifs.makon.com.Repository;

import com.jeueducatifs.makon.com.Model.Administrateur;
import com.jeueducatifs.makon.com.Model.Apprenant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository

public interface AdministrateurRepository  extends JpaRepository<Administrateur, Integer> {
}
