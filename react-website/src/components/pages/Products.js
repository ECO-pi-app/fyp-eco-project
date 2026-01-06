import React from 'react';
import '../../App.css';

export default function Products() {
  return (
    <div
      className="products"
      style={{ backgroundImage: `url(${process.env.PUBLIC_URL}/images/img-1.jpg)` }}
    >
      PRODUCTS
    </div>
  );
}