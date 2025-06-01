import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Header from './components/Header';
import SearchFilter from './components/SearchFilter';
import ItemsTable from './components/ItemsTable';
import ItemModal from './components/ItemModal';
import ConfirmModal from './components/ConfirmModal';
import Toast from './components/Toast';

// Configuração da API otimizada para produção
const API_BASE_URL = process.env.NODE_ENV === 'production' 
  ? '' // Em produção, usar relative URL (Nginx faz proxy)
  : 'http://localhost:3001';
const API_URL = `${API_BASE_URL}/api/items`;

function App() {
  const [items, setItems] = useState([]);
  const [filteredItems, setFilteredItems] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const [itemToDelete, setItemToDelete] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterValue, setFilterValue] = useState('all');
  const [showItemModal, setShowItemModal] = useState(false);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [toast, setToast] = useState({ show: false, message: '', type: 'success' });
  const itemsPerPage = 5;

  // Carregar dados da API
  const fetchItems = async () => {
    try {
      const response = await axios.get(API_URL);
      setItems(response.data);
    } catch (error) {
      console.error('Erro ao buscar dados:', error);
      showToastMessage('Erro ao buscar dados', 'error');
    }
  };

  useEffect(() => {
    fetchItems();
  }, [fetchItems]); // Incluir fetchItems como dependência

  // Filtrar itens quando os critérios mudarem
  useEffect(() => {
    const filtered = items.filter(item => {
      const matchesSearch = 
        item.name.toLowerCase().includes(searchTerm.toLowerCase()) || 
        item.description.toLowerCase().includes(searchTerm.toLowerCase());
      const matchesFilter = filterValue === 'all' || item.status === filterValue;
      return matchesSearch && matchesFilter;
    });
    
    setFilteredItems(filtered);
    setCurrentPage(1);
  }, [items, searchTerm, filterValue]);

  // Mostrar mensagem toast
  const showToastMessage = (message, type = 'success') => {
    setToast({ show: true, message, type });
    setTimeout(() => setToast({ show: false, message: '', type: 'success' }), 3000);
  };

  // Adicionar novo item
  const handleAddItem = () => {
    setEditingItem(null);
    setShowItemModal(true);
  };

  // Editar item existente
  const handleEditItem = async (id) => {
    try {
      const response = await axios.get(`${API_URL}/${id}`);
      setEditingItem(response.data);
      setShowItemModal(true);
    } catch (error) {
      console.error('Erro ao buscar item:', error);
      showToastMessage('Erro ao editar item', 'error');
    }
  };

  // Excluir item
  const handleDeleteItem = (id) => {
    setItemToDelete(id);
    setShowConfirmModal(true);
  };

  // Confirmar exclusão
  const confirmDelete = async () => {
    try {
      await axios.delete(`${API_URL}/${itemToDelete}`);
      fetchItems();
      setShowConfirmModal(false);
      showToastMessage('Item excluído com sucesso');
    } catch (error) {
      console.error('Erro ao excluir item:', error);
      showToastMessage('Erro ao excluir item', 'error');
    }
  };

  // Salvar item (novo ou existente)
  const handleSaveItem = async (itemData) => {
    try {
      if (editingItem) {
        await axios.put(`${API_URL}/${editingItem.id}`, itemData);
        showToastMessage('Item atualizado com sucesso');
      } else {
        await axios.post(API_URL, itemData);
        showToastMessage('Item adicionado com sucesso');
      }
      fetchItems();
      setShowItemModal(false);
    } catch (error) {
      console.error('Erro ao salvar item:', error);
      showToastMessage('Erro ao salvar item', 'error');
    }
  };

  // Calcular itens da página atual
  const currentItems = filteredItems.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );

  // Calcular informações de paginação
  const totalItems = filteredItems.length;
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  const startItem = totalItems === 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
  const endItem = Math.min(currentPage * itemsPerPage, totalItems);

  return (
    <div className="container mx-auto px-4 py-8 max-w-6xl">
      <Header 
        onRefresh={fetchItems} 
        onAddItem={handleAddItem} 
      />
      
      <SearchFilter 
        searchTerm={searchTerm} 
        onSearchChange={setSearchTerm} 
        filterValue={filterValue} 
        onFilterChange={setFilterValue} 
      />
      
      <ItemsTable 
        items={currentItems}
        currentPage={currentPage}
        totalPages={totalPages}
        onPageChange={setCurrentPage}
        onEdit={handleEditItem}
        onDelete={handleDeleteItem}
        startItem={startItem}
        endItem={endItem}
        totalItems={totalItems}
      />
      
      {showItemModal && (
        <ItemModal 
          item={editingItem}
          onClose={() => setShowItemModal(false)}
          onSave={handleSaveItem}
        />
      )}
      
      {showConfirmModal && (
        <ConfirmModal 
          onClose={() => setShowConfirmModal(false)}
          onConfirm={confirmDelete}
        />
      )}
      
      <Toast 
        show={toast.show}
        message={toast.message}
        type={toast.type}
      />
    </div>
  );
}

export default App;
