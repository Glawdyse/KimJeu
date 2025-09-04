package com.jeueducatifs.makon.com.Repository;


import com.jeueducatifs.makon.com.Model.Notifications;
import com.jeueducatifs.makon.com.Model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationsRepository extends JpaRepository<Notifications,Integer> {


    List<Notifications> findByIsReadFalse();

    List<Notifications> findByUserId(Integer userId);

    List<Notifications> findByUserOrderByDateNotifDesc(User user);

    List<Notifications> findAllByOrderByDateNotifDesc();
}
