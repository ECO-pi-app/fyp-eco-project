import React from 'react'
import { Link } from 'react-router-dom'

function CardItem(props) {
  const Wrapper = props.external ? 'a' : Link;
  const wrapperProps = props.external
    ? { className: "cards__item__link", href: props.path, target: "_blank", rel: "noreferrer" }
    : { className: "cards__item__link", to: props.path };

  return (
    <>
      <li className='cards__item'>
        <Wrapper {...wrapperProps}>
          <figure className='cards__item__pic-wrap' data-category={props.label}>
            <img
              src={props.src}
              alt="Sustainability Image"
              className='cards__item__img'
              onError={(e) => {
              e.target.onerror = null;
              e.target.src = "/images/img-9.jpg";
              }}
            />
          </figure>
          <div className='cards__item__info'>
            <h5 className="cards__item__text">{props.text}</h5>
          </div>
        </Wrapper>
      </li>
    </>
  )
}

export default CardItem
