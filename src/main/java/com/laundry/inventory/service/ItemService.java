package com.laundry.inventory.service;

import com.laundry.inventory.model.Item;
import com.laundry.inventory.repository.ItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class ItemService {
    
    @Autowired
    private ItemRepository itemRepository;
    
    public List<Item> getAllItems() {
        return itemRepository.findAll();
    }
    
    public Optional<Item> getItemById(Long id) {
        return itemRepository.findById(id);
    }
    
    public Item createItem(Item item) {
        return itemRepository.save(item);
    }
    
    public Item updateItem(Long id, Item itemDetails) {
        Item item = itemRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Item not found with id: " + id));
        
        item.setName(itemDetails.getName());
        item.setCategory(itemDetails.getCategory());
        item.setQuantity(itemDetails.getQuantity());
        item.setUnit(itemDetails.getUnit());
        item.setPricePerUnit(itemDetails.getPricePerUnit());
        item.setMinimumStock(itemDetails.getMinimumStock());
        item.setSupplier(itemDetails.getSupplier());
        item.setDescription(itemDetails.getDescription());
        
        return itemRepository.save(item);
    }
    
    public void deleteItem(Long id) {
        Item item = itemRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Item not found with id: " + id));
        itemRepository.delete(item);
    }
    
    public List<Item> searchItems(String query) {
        return itemRepository.findByNameContainingIgnoreCase(query);
    }
    
    public List<Item> getItemsByCategory(String category) {
        return itemRepository.findByCategory(category);
    }
    
    public List<Item> getLowStockItems() {
        return itemRepository.findAll().stream()
            .filter(item -> item.getMinimumStock() != null && 
                           item.getQuantity() <= item.getMinimumStock())
            .collect(Collectors.toList());
    }
    
    public Item updateStock(Long id, Integer quantityChange) {
        Item item = itemRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Item not found with id: " + id));
        
        int newQuantity = item.getQuantity() + quantityChange;
        if (newQuantity < 0) {
            throw new RuntimeException("Insufficient stock");
        }
        
        item.setQuantity(newQuantity);
        return itemRepository.save(item);
    }
}
