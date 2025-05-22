import React from 'react';

function Header({ onRefresh, onAddItem }) {
  return (
    <header className="mb-8">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-indigo-700">
          <i className="fas fa-database mr-2"></i> Aplicação de CRUD
        </h1>
        <div className="flex space-x-4">
          <button 
            onClick={onRefresh}
            className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition"
          >
            <i className="fas fa-sync-alt mr-2"></i>Atualizar
          </button>
          <button 
            onClick={onAddItem}
            className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition"
          >
            <i className="fas fa-plus mr-2"></i>Adicionar Item
          </button>
        </div>
      </div>
      <p className="text-gray-600 mt-2">Uma interface simples para gerenciar seus dados</p>
    </header>
  );
}

export default Header;
