package com.jeueducatifs.makon.com.Repository;


import com.jeueducatifs.makon.com.Model.Educateur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EducateurRepository extends JpaRepository<Educateur, Long> {

}
