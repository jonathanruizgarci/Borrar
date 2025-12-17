import React, { useState, useRef, useEffect } from 'react';
import { ChevronLeft, ChevronRight, Calendar } from 'lucide-react';

const DateSelector = ({ selectedDate, setSelectedDate, mode = 'day' }) => {
  const [isCalendarOpen, setIsCalendarOpen] = useState(false);
  const calendarRef = useRef(null);

  const addTime = (amount) => {
    const result = new Date(selectedDate);
    if (mode === 'month') {
        result.setMonth(result.getMonth() + amount);
    } else {
        result.setDate(result.getDate() + amount);
    }
    setSelectedDate(result);
  };

  // Función para formatear la fecha en formato YYYY-MM-DD (para input type="date")
  const formatDateForInput = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  // Función para formatear mes en formato YYYY-MM (para input type="month")
  const formatMonthForInput = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    return `${year}-${month}`;
  };

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (calendarRef.current && !calendarRef.current.contains(event.target)) {
        setIsCalendarOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <div ref={calendarRef} className="flex items-center relative z-20 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg shadow-sm p-0.5">
      
      {/* Botón Atrás */}
      <button onClick={() => addTime(-1)} className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md text-gray-500 dark:text-gray-400 transition-colors">
        <ChevronLeft size={18} />
      </button>
      
      {/* Zona Central */}
      <div className="relative">
        <button 
          onClick={() => setIsCalendarOpen(!isCalendarOpen)}
          className={`flex items-center gap-2 px-3 py-2 text-sm md:text-sm font-medium rounded-md transition-colors 
            ${isCalendarOpen 
              ? 'bg-blue-50 text-blue-600 dark:bg-blue-900/30 dark:text-blue-300' 
              : 'text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-700'}`}
        >
          <Calendar size={16} className={isCalendarOpen ? "text-blue-600 dark:text-blue-300" : "text-gray-500 dark:text-gray-400"} />
          
          <span className="capitalize whitespace-nowrap">
            {mode === 'month' ? (
                <>
                    <span className="md:hidden">
                        {new Intl.DateTimeFormat('es-ES', { month: 'short', year: 'numeric' }).format(selectedDate)}
                    </span>
                    <span className="hidden md:inline">
                        {new Intl.DateTimeFormat('es-ES', { month: 'long', year: 'numeric' }).format(selectedDate)}
                    </span>
                </>
            ) : (
                new Intl.DateTimeFormat('es-ES', { day: 'numeric', month: 'short' }).format(selectedDate)
            )}
          </span>
        </button>

        {isCalendarOpen && (
          <div className={`
              absolute top-full mt-1 
              ${mode === 'month' 
                ? 'left-1/2 -translate-x-1/2 md:left-1/2 md:-translate-x-1/2' 
                : 'right-0 md:left-auto md:right-0'} 
              z-50 
              bg-white dark:bg-gray-800 
              shadow-xl rounded-xl border border-gray-200 dark:border-gray-700 
              animate-in fade-in zoom-in duration-200 origin-top
              min-w-[160px] max-w-[90vw] p-2
          `}>
              <div className="space-y-1.5">
                <label className="block text-[10px] text-gray-500 dark:text-gray-400 font-bold uppercase tracking-wider text-left px-1">
                  FECHA:
                </label>
               
               <input 
                 type={mode === 'month' ? "month" : "date"} 
                 className="w-full p-1 border border-gray-300 dark:border-gray-600 rounded-lg outline-none text-gray-700 dark:text-white text-xs bg-gray-50 dark:bg-gray-900"
                 value={
                    mode === 'month'
                    ? formatMonthForInput(selectedDate)
                    : formatDateForInput(selectedDate)
                 }
                 onChange={(e) => {
                   if(e.target.value) {
                       const dateString = e.target.value;
                       let newDate;
                       
                       if (mode === 'month') {
                         newDate = new Date(dateString + '-01T12:00:00');
                       } else {
                         newDate = new Date(dateString + 'T12:00:00');
                       }
                       
                       setSelectedDate(newDate);
                   }
                 }}
               />
               
               <button 
                 onClick={() => setIsCalendarOpen(false)}
                 className="w-full py-1 bg-blue-600 hover:bg-blue-700 text-white text-xs font-medium rounded-lg shadow-sm transition-colors"
               >
                 Aplicar
               </button>
             </div>
          </div>
        )}
      </div>

      {/* Botón Adelante */}
      <button onClick={() => addTime(1)} className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md text-gray-500 dark:text-gray-400 transition-colors">
        <ChevronRight size={18} />
      </button>
    </div>
  );
};

export default DateSelector;