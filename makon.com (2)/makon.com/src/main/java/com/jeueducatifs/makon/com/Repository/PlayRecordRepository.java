package com.jeueducatifs.makon.com.Repository;

import com.jeueducatifs.makon.com.Model.PlayRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository

public interface PlayRecordRepository extends JpaRepository<PlayRecord, String> {

}

