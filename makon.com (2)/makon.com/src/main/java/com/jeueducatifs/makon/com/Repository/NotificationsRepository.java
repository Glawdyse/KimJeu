package com.jeueducatifs.makon.com.Repository;


import com.jeueducatifs.makon.com.Model.Notifications;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationsRepository extends JpaRepository<Notifications,Integer> {


}
