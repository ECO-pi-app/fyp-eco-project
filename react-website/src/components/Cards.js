import React, { useEffect, useState } from 'react';
import CardItem from './Carditem';
import './Cards.css';

function Cards() {
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('http://127.0.0.1:8000/news/sustainability')
      .then((res) => res.json())
      .then((data) => {
        setArticles(data.articles || []);
        setLoading(false);
      })
      .catch((err) => {
        console.error(err);
        setLoading(false);
      });
  }, []);

  return (
    <div className='cards'>
      <h1>SUSTAINABILITY NEWS!</h1>
      <div className='cards__container'>
        <div className="cards__wrapper">
          <ul className='cards__items'>
            {/*  SKELETONS while loading */}
            {loading &&
              Array.from({ length: 8 }).map((_, i) => (
                <li className="cards__item" key={`sk-${i}`}>
                  <div className="cards__item__link">
                    <div className="cards__item__pic-wrap skeleton skeleton__img" />
                    <div className="cards__item__info">
                      <div className="skeleton skeleton__text" />
                      <div className="skeleton skeleton__text skeleton__text--short" />
                    </div>
                  </div>
                </li>
              ))
            }

            {/* ✅ REAL cards after loading */}
            {!loading && articles.slice(0, 8).map((a, i) => (
              <CardItem
                key={i}
                src={a.image_url || "images/img-9.jpg"}
                text={a.title}
                label={a.source || "News"}
                path={a.url}
                external={true}
              />
            ))}

          </ul>
        </div>
      </div>
    </div>
  );
}

export default Cards;