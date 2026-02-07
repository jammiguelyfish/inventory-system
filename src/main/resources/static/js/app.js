// API Base URL
const API_URL = 'http://localhost:8080/api/items';

// Current edit item ID
let currentEditId = null;
let currentStockItemId = null;

// Load all items on page load
document.addEventListener('DOMContentLoaded', function() {
    loadAllItems();
    checkLowStock();
});

// Load all items from API
async function loadAllItems() {
    try {
        const response = await fetch(API_URL);
        const items = await response.json();
        displayItems(items);
    } catch (error) {
        console.error('Error loading items:', error);
        showError('Failed to load inventory items');
    }
}

// Display items in table
function displayItems(items) {
    const tbody = document.getElementById('inventoryTableBody');
    
    if (items.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="10" class="empty-state">
                    <h3>No items found</h3>
                    <p>Start by adding your first inventory item</p>
                </td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = items.map(item => `
        <tr>
            <td>${item.id}</td>
            <td><strong>${item.name}</strong></td>
            <td>${item.category}</td>
            <td>${item.quantity}</td>
            <td>${item.unit}</td>
            <td>${item.pricePerUnit ? '₱' + item.pricePerUnit.toFixed(2) : '-'}</td>
            <td>${item.minimumStock || '-'}</td>
            <td>${item.supplier || '-'}</td>
            <td>${getStatusBadge(item)}</td>
            <td>
                <div class="action-buttons">
                    <button onclick="openStockModal(${item.id})" class="btn btn-success">📦 Stock</button>
                    <button onclick="openEditModal(${item.id})" class="btn btn-info">✏️ Edit</button>
                    <button onclick="deleteItem(${item.id})" class="btn btn-danger">🗑️ Delete</button>
                </div>
            </td>
        </tr>
    `).join('');
}

// Get status badge based on stock level
function getStatusBadge(item) {
    if (!item.minimumStock) {
        return '<span class="status-badge status-ok">OK</span>';
    }
    
    if (item.quantity <= item.minimumStock / 2) {
        return '<span class="status-badge status-critical">Critical</span>';
    } else if (item.quantity <= item.minimumStock) {
        return '<span class="status-badge status-low">Low Stock</span>';
    } else {
        return '<span class="status-badge status-ok">OK</span>';
    }
}

// Check for low stock items
async function checkLowStock() {
    try {
        const response = await fetch(`${API_URL}/low-stock`);
        const lowStockItems = await response.json();
        
        const alertDiv = document.getElementById('lowStockAlert');
        const countSpan = document.getElementById('lowStockCount');
        
        if (lowStockItems.length > 0) {
            countSpan.textContent = lowStockItems.length;
            alertDiv.style.display = 'flex';
        } else {
            alertDiv.style.display = 'none';
        }
    } catch (error) {
        console.error('Error checking low stock:', error);
    }
}

// Show low stock items
async function showLowStock() {
    try {
        const response = await fetch(`${API_URL}/low-stock`);
        const items = await response.json();
        displayItems(items);
    } catch (error) {
        console.error('Error loading low stock items:', error);
    }
}

// Search items
async function searchItems() {
    const query = document.getElementById('searchInput').value.trim();
    
    if (!query) {
        loadAllItems();
        return;
    }
    
    try {
        const response = await fetch(`${API_URL}/search?query=${encodeURIComponent(query)}`);
        const items = await response.json();
        displayItems(items);
    } catch (error) {
        console.error('Error searching items:', error);
        showError('Failed to search items');
    }
}

// Filter by category
async function filterByCategory() {
    const category = document.getElementById('categoryFilter').value;
    
    if (!category) {
        loadAllItems();
        return;
    }
    
    try {
        const response = await fetch(`${API_URL}/category/${encodeURIComponent(category)}`);
        const items = await response.json();
        displayItems(items);
    } catch (error) {
        console.error('Error filtering items:', error);
        showError('Failed to filter items');
    }
}

// Open add modal
function openAddModal() {
    currentEditId = null;
    document.getElementById('modalTitle').textContent = 'Add New Item';
    document.getElementById('itemForm').reset();
    document.getElementById('itemId').value = '';
    document.getElementById('itemModal').style.display = 'block';
}

// Open edit modal
async function openEditModal(id) {
    try {
        const response = await fetch(`${API_URL}/${id}`);
        const item = await response.json();
        
        currentEditId = id;
        document.getElementById('modalTitle').textContent = 'Edit Item';
        document.getElementById('itemId').value = item.id;
        document.getElementById('itemName').value = item.name;
        document.getElementById('itemCategory').value = item.category;
        document.getElementById('itemQuantity').value = item.quantity;
        document.getElementById('itemUnit').value = item.unit;
        document.getElementById('itemPrice').value = item.pricePerUnit || '';
        document.getElementById('itemMinStock').value = item.minimumStock || '';
        document.getElementById('itemSupplier').value = item.supplier || '';
        document.getElementById('itemDescription').value = item.description || '';
        
        document.getElementById('itemModal').style.display = 'block';
    } catch (error) {
        console.error('Error loading item:', error);
        showError('Failed to load item details');
    }
}

// Close modal
function closeModal() {
    document.getElementById('itemModal').style.display = 'none';
    currentEditId = null;
}

// Save item (create or update)
async function saveItem(event) {
    event.preventDefault();
    
    const itemData = {
        name: document.getElementById('itemName').value,
        category: document.getElementById('itemCategory').value,
        quantity: parseInt(document.getElementById('itemQuantity').value),
        unit: document.getElementById('itemUnit').value,
        pricePerUnit: parseFloat(document.getElementById('itemPrice').value) || null,
        minimumStock: parseInt(document.getElementById('itemMinStock').value) || null,
        supplier: document.getElementById('itemSupplier').value || null,
        description: document.getElementById('itemDescription').value || null
    };
    
    try {
        let response;
        if (currentEditId) {
            // Update existing item
            response = await fetch(`${API_URL}/${currentEditId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(itemData)
            });
        } else {
            // Create new item
            response = await fetch(API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(itemData)
            });
        }
        
        if (response.ok) {
            closeModal();
            loadAllItems();
            checkLowStock();
            showSuccess(currentEditId ? 'Item updated successfully' : 'Item added successfully');
        } else {
            showError('Failed to save item');
        }
    } catch (error) {
        console.error('Error saving item:', error);
        showError('Failed to save item');
    }
}

// Delete item
async function deleteItem(id) {
    if (!confirm('Are you sure you want to delete this item?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_URL}/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            loadAllItems();
            checkLowStock();
            showSuccess('Item deleted successfully');
        } else {
            showError('Failed to delete item');
        }
    } catch (error) {
        console.error('Error deleting item:', error);
        showError('Failed to delete item');
    }
}

// Open stock adjustment modal
async function openStockModal(id) {
    try {
        const response = await fetch(`${API_URL}/${id}`);
        const item = await response.json();
        
        currentStockItemId = id;
        document.getElementById('stockItemId').value = id;
        document.getElementById('stockItemName').textContent = item.name;
        document.getElementById('stockCurrentQty').textContent = item.quantity;
        document.getElementById('stockUnit').textContent = item.unit;
        document.getElementById('stockQuantity').value = '';
        
        // Reset radio buttons
        document.querySelector('input[name="adjustmentType"][value="add"]').checked = true;
        
        document.getElementById('stockModal').style.display = 'block';
    } catch (error) {
        console.error('Error loading item:', error);
        showError('Failed to load item details');
    }
}

// Close stock modal
function closeStockModal() {
    document.getElementById('stockModal').style.display = 'none';
    currentStockItemId = null;
}

// Adjust stock
async function adjustStock(event) {
    event.preventDefault();
    
    const quantity = parseInt(document.getElementById('stockQuantity').value);
    const adjustmentType = document.querySelector('input[name="adjustmentType"]:checked').value;
    const quantityChange = adjustmentType === 'add' ? quantity : -quantity;
    
    try {
        const response = await fetch(`${API_URL}/${currentStockItemId}/stock`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ quantityChange })
        });
        
        if (response.ok) {
            closeStockModal();
            loadAllItems();
            checkLowStock();
            showSuccess('Stock updated successfully');
        } else {
            const error = await response.text();
            showError(error || 'Failed to update stock');
        }
    } catch (error) {
        console.error('Error updating stock:', error);
        showError('Failed to update stock');
    }
}

// Show success message
function showSuccess(message) {
    alert('✅ ' + message);
}

// Show error message
function showError(message) {
    alert('❌ ' + message);
}

// Close modals when clicking outside
window.onclick = function(event) {
    const itemModal = document.getElementById('itemModal');
    const stockModal = document.getElementById('stockModal');
    
    if (event.target === itemModal) {
        closeModal();
    }
    if (event.target === stockModal) {
        closeStockModal();
    }
}
