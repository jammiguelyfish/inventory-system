package com.laundry.inventory.repository;

import com.laundry.inventory.model.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ItemRepository extends JpaRepository<Item, Long> {
    
    List<Item> findByCategory(String category);
    
    List<Item> findByNameContainingIgnoreCase(String name);
    
    List<Item> findByQuantityLessThanEqual(Integer quantity);
}
