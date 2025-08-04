package com.jeueducatifs.makon.com.Repository;

import com.jeueducatifs.makon.com.Model.Administrateur;
import com.jeueducatifs.makon.com.Model.Contenu_educatif;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface Contenu_educatifRepository extends JpaRepository<Contenu_educatif, Integer> {
}
