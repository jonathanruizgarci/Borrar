import React, { useState } from 'react';
import {
    ResponsiveContainer, XAxis, YAxis, Tooltip, CartesianGrid,
    AreaChart, Area,
    BarChart, Bar,
    LineChart, Line,
    Legend
} from 'recharts';
import { Loader2, BarChart2, Activity, Layers } from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';

// Botón pequeño para el selector (con soporte Dark Mode)
const ChartToggleButton = ({ active, onClick, icon: Icon, title }) => (
    <button
        onClick={onClick}
        title={title}
        className={`p-1.5 rounded-md transition-all duration-200 ${active
            ? 'bg-blue-100 text-blue-600 dark:bg-blue-900/40 dark:text-blue-400 shadow-sm ring-1 ring-blue-200 dark:ring-blue-800'
            : 'text-gray-400 dark:text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-700 hover:text-gray-600 dark:hover:text-gray-300'
            }`}
    >
        <Icon size={18} />
    </button>
);

const ChartCard = ({
    title,
    data,
    dataKey,
    color = "#3b82f6",
    loading,
    noDataMessage,
    unit = "",
    series = [],
    sensorCategories = [],
    categoryIcons = {},
    categoryLabels = {}
}) => {
    const [chartType, setChartType] = useState('area');
    const [hiddenSeries, setHiddenSeries] = useState([]);
    const { isDarkMode } = useTheme();

    const toggleSeries = (key) => {
        setHiddenSeries(prev =>
            prev.includes(key) ? prev.filter(k => k !== key) : [...prev, key]
        );
    };

    // --- CUSTOM LEGEND RENDERER ---
    const renderLegend = (props) => {
        const { payload } = props;
        return (
            <div className="flex flex-wrap justify-center gap-2 mb-6 px-4">
                {payload.map((entry, index) => {
                    const isHidden = hiddenSeries.includes(entry.dataKey);
                    return (
                        <button
                            key={`item-${index}`}
                            onClick={() => toggleSeries(entry.dataKey)}
                            className={`
                                flex items-center gap-2 px-3 py-1 rounded border-2 transition-all text-sm font-semibold
                                ${isHidden ? 'opacity-50 line-through' : 'opacity-100'}
                            `}
                            style={{
                                borderColor: entry.color,
                                color: '#374151', // Dark grey text as in screenshot
                                backgroundColor: isHidden ? '#f3f4f6' : 'rgba(255,255,255,0.8)' // White-ish bg
                            }}
                        >
                            {/* Color Square/Line Indicator (Optional, but screenshot shows text inside box) */}
                            {/* For exact match: Just the box with text is visible in screenshot, 
                                but having a small indicator is standard. Let's stick to BOX style. 
                            */}
                            <span
                                className="w-4 h-1 rounded flex-shrink-0"
                                style={{ backgroundColor: entry.color }}
                            />
                            {entry.value}
                        </button>
                    );
                })}
            </div>
        );
    };

    if (loading) {
        return (
            <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 w-full flex flex-col h-[500px]">
                <div className="flex flex-col items-center mb-4">
                    <h3 className="text-2xl font-normal text-gray-900 dark:text-white mb-2">{title}</h3>
                    <div className="w-full h-[2px] bg-green-700/80 rounded-full max-w-md"></div>
                </div>
                <div className="flex-1 flex items-center justify-center bg-gray-50 dark:bg-gray-900/50 rounded-lg">
                    <Loader2 className="animate-spin text-blue-500" size={40} />
                </div>
            </div>
        );
    }

    if (noDataMessage || !data || data.length === 0) {
        return (
            <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 w-full flex flex-col h-[500px]">
                <div className="flex flex-col items-center mb-4">
                    <h3 className="text-2xl font-normal text-gray-900 dark:text-white mb-2">{title}</h3>
                    <div className="w-full h-[2px] bg-green-700/80 rounded-full max-w-md"></div>
                </div>
                <div className="flex-1 flex items-center justify-center bg-gray-50 dark:bg-gray-900/50 rounded-lg text-gray-400 italic">
                    {noDataMessage || "No hay datos disponibles"}
                </div>
            </div>
        );
    }

    // --- RENDER CHART ---
    const renderChart = () => {
        const commonProps = {
            data: data,
            margin: { top: 10, right: 10, left: 0, bottom: 20 } // Increased bottom margin for rotated labels
        };

        const ChartComponent = {
            area: AreaChart,
            bar: BarChart,
            line: LineChart
        }[chartType];

        const axisColor = "#9ca3af"; // Consistent gray
        const gridColor = "#e5e7eb"; // Light gray grid

        const isMulti = series && series.length > 0;

        return (
            <ResponsiveContainer width="100%" height="100%">
                <ChartComponent {...commonProps}>
                    <defs>
                        {!isMulti && (
                            <linearGradient id={`color${dataKey}`} x1="0" y1="0" x2="0" y2="1">
                                <stop offset="5%" stopColor={color} stopOpacity={0.3} />
                                <stop offset="95%" stopColor={color} stopOpacity={0.05} />
                            </linearGradient>
                        )}
                        {isMulti && series.map((s, idx) => (
                            <linearGradient key={idx} id={`color${s.key}`} x1="0" y1="0" x2="0" y2="1">
                                <stop offset="5%" stopColor={s.color} stopOpacity={0.2} />
                                <stop offset="95%" stopColor={s.color} stopOpacity={0.0} />
                            </linearGradient>
                        ))}
                    </defs>

                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke={gridColor} />

                    <XAxis
                        dataKey="name"
                        stroke={axisColor}
                        tick={{ fontSize: 12, fill: '#6b7280' }}
                        tickLine={false}
                        axisLine={false}
                        dy={10}
                        minTickGap={20}
                        angle={-45} // Rotate labels like in screenshot
                        textAnchor="end"
                        height={60} // Reserve space for rotated labels
                    />

                    <YAxis
                        stroke={axisColor}
                        tick={{ fontSize: 12, fill: '#6b7280' }}
                        tickLine={false}
                        axisLine={false}
                        width={40}
                        label={{ value: unit, angle: -90, position: 'insideLeft', style: { textAnchor: 'middle', fill: '#9ca3af', fontSize: 12 } }}
                    />

                    <Tooltip
                        contentStyle={{
                            backgroundColor: isDarkMode ? "#1f2937" : "rgba(255,255,255,0.95)",
                            borderColor: isDarkMode ? "#374151" : "#e5e7eb",
                            borderRadius: '8px',
                            boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)'
                        }}
                        labelStyle={{ color: '#111827', fontWeight: 'bold' }}
                        itemStyle={{ color: '#4b5563' }}
                        formatter={(value, name) => [`${value} ${unit}`, name]}
                    />

                    {isMulti && <Legend content={renderLegend} verticalAlign="top" />}

                    {/* SINGLE SERIES MODE */}
                    {!isMulti && chartType === 'area' && (
                        <Area
                            type="monotone"
                            dataKey={dataKey}
                            stroke={color}
                            strokeWidth={3}
                            fillOpacity={1}
                            fill={`url(#color${dataKey})`}
                            // Hollow dots style
                            dot={{ r: 5, strokeWidth: 2, fill: '#fff', stroke: color }}
                            activeDot={{ r: 7, strokeWidth: 2, fill: color, stroke: '#fff' }}
                        />
                    )}
                    {!isMulti && chartType === 'bar' && (
                        <Bar dataKey={dataKey} fill={color} radius={[4, 4, 0, 0]} barSize={30} />
                    )}
                    {!isMulti && chartType === 'line' && (
                        <Line
                            type="monotone"
                            dataKey={dataKey}
                            stroke={color}
                            strokeWidth={3}
                            // Hollow dots style
                            dot={{ r: 5, strokeWidth: 2, fill: '#fff', stroke: color }}
                            activeDot={{ r: 7, strokeWidth: 2, fill: color, stroke: '#fff' }}
                        />
                    )}

                    {/* MULTI SERIES MODE */}
                    {isMulti && series.map((s) => {
                        const isHidden = hiddenSeries.includes(s.key);
                        if (chartType === 'area')
                            return (
                                <Area
                                    key={s.key}
                                    type="monotone"
                                    dataKey={s.key}
                                    name={s.name}
                                    stroke={s.color}
                                    fill={`url(#color${s.key})`}
                                    fillOpacity={1}
                                    hide={isHidden}
                                    // Hollow dots per series
                                    dot={{ r: 5, strokeWidth: 2, fill: '#fff', stroke: s.color }}
                                    activeDot={{ r: 7, strokeWidth: 2, fill: s.color, stroke: '#fff' }}
                                />
                            );
                        if (chartType === 'bar')
                            return <Bar key={s.key} dataKey={s.key} name={s.name} fill={s.color} hide={isHidden} />;
                        return (
                            <Line
                                key={s.key}
                                type="monotone"
                                dataKey={s.key}
                                name={s.name}
                                stroke={s.color}
                                hide={isHidden}
                                strokeWidth={3}
                                dot={{ r: 5, strokeWidth: 2, fill: '#fff', stroke: s.color }}
                                activeDot={{ r: 7, strokeWidth: 2, fill: s.color, stroke: '#fff' }}
                            />
                        );
                    })}

                </ChartComponent>
            </ResponsiveContainer>
        );
    };

    return (
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-lg border border-gray-100 dark:border-gray-700 w-full h-[550px] flex flex-col hover:shadow-xl transition-all duration-300">

            {/* TITULO CENTRADO + SEPARADOR VERDE */}
            <div className="flex flex-col items-center mb-6 relative">
                <h3 className="text-3xl font-normal text-gray-900 dark:text-white mb-3 tracking-wide">{title}</h3>
                <div className="w-full h-[3px] bg-green-700 transform skew-x-12" style={{ maxWidth: '90%' }}></div>

                {/* CATEGORY BADGES (Solo si hay sensores agrupados) */}
                {sensorCategories.length > 0 && (
                    <div className="flex gap-2 mt-3">
                        {sensorCategories.map(cat => (
                            <div
                                key={cat}
                                className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-gray-100 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 text-xs font-semibold text-gray-700 dark:text-gray-300"
                            >
                                <span className="text-base">{categoryIcons[cat] || '📊'}</span>
                                <span>{categoryLabels[cat] || cat}</span>
                            </div>
                        ))}
                    </div>
                )}

                {/* SELECTOR DE ESTILO (Flotante o Absolute si fuera necesario, aqui lo dejo en flex) */}
                <div className="absolute right-0 top-0 hidden sm:flex bg-gray-50 dark:bg-gray-700/50 p-1 rounded-lg border border-gray-100 dark:border-gray-600 gap-1 opacity-50 hover:opacity-100 transition-opacity">
                    <ChartToggleButton active={chartType === 'area'} onClick={() => setChartType('area')} icon={Layers} title="Área" />
                    <ChartToggleButton active={chartType === 'bar'} onClick={() => setChartType('bar')} icon={BarChart2} title="Barras" />
                    <ChartToggleButton active={chartType === 'line'} onClick={() => setChartType('line')} icon={Activity} title="Línea" />
                </div>
            </div>

            <div className="flex-1 w-full min-w-0 min-h-0 relative px-2">
                {renderChart()}
            </div>
        </div>
    );
};

export default ChartCard;