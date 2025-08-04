package com.jeueducatifs.makon.com.Repository;

import com.jeueducatifs.makon.com.Model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    // Cette méthode est automatiquement fournie par JpaRepository
    // Vous n'avez pas besoin de la redéfinir
    Optional<User> findById(Integer id);

    @Query("SELECT u FROM User u WHERE u.nomPrenom = :nomPrenom")
    Optional<User> findByNomPrenom(@Param("nomPrenom") String nomPrenom);

    // Cette méthode est automatiquement fournie par Spring Data JPA
    // Vous n'avez pas besoin de la redéfinir
     Optional<User> findByEmail(String email) ;

    Optional<User> findByRole(User.Role role);

}




