import React from 'react';

function Toast({ show, message, type }) {
  if (!show) return null;

  const bgColor = type === 'success' ? 'bg-green-500' : 'bg-red-500';

  return (
    <div className="fixed bottom-4 right-4">
      <div className={`${bgColor} text-white px-4 py-2 rounded-lg shadow-lg flex items-center`}>
        <i className={`fas ${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'} mr-2`}></i>
        <span>{message}</span>
      </div>
    </div>
  );
}

export default Toast;
