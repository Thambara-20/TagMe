import React, { useState } from "react";
import Image1 from "../assets/images/image-product-1.jpg";
import Image2 from "../assets/images/image-product-2.jpg";
import Image3 from "../assets/images/image-product-3.jpg";
import Image4 from "../assets/images/image-product-4.jpg";
import ClosePrev from "../assets/images/icon-close.svg";
import PrevBtn from "../assets/images/icon-previous.svg";
import NextBtn from "../assets/images/icon-next.svg";
import "../styles/Hero.css";
import shortid from "shortid";
import { useDispatch } from "react-redux";
import { IconButton } from "@material-ui/core";
import { GetApp as DownloadIcon } from "@material-ui/icons";
import { Android } from "@material-ui/icons";

// call the action I will use
import { add_items } from "../actions";

const Hero = () => {
  // declare dispatch function
  const dispatch = useDispatch();

  // increase or decrease desired item quantity before checkout
  const [itemQuantity, setItemQuantity] = useState(0);
  const incNum = () => {
    setItemQuantity(itemQuantity + 1);
    setItems({
      ...items,
      added_items: itemQuantity + 1,
      total_price: 125 * (itemQuantity + 1),
    });
  };
  const decNum = () => {
    if (itemQuantity > 0) {
      setItemQuantity(itemQuantity - 1);
      setItems({
        ...items,
        added_items: itemQuantity - 1,
        total_price: 125 * (itemQuantity - 1),
      });
    } else {
      setItemQuantity(0);
    }
  };

  // add item to cart if quantity is more than 0
  const download = () => {
    // Add your download logic here
    console.log("Downloading...");
  };

  //cart item object
  const [items, setItems] = useState({
    id: shortid.generate(),
    added_items: 0,
    total_price: 0,
  });

  // desktop gallery modal
  const [photoModal, setPhotoModal] = useState(false);
  const togglePhotoModal = () => {
    setPhotoModal(!photoModal);
    setActiveModalImage(activeImage);
  };

  // set active images in modal and preview view
  const galleryArray = [Image1, Image2, Image3, Image4];

  // set active image
  const [activeImage, setActiveImage] = useState(galleryArray[0]);
  const adjustActiveImage = (index) => {
    setActiveImage(index);
    // what ever the user's image was before opening modal will display as active modal image
    setActiveModalImage(index);
  };

  // set active modal image
  const [activeModalImage, setActiveModalImage] = useState(activeImage);
  const adjustActiveModalImage = (index) => {
    setActiveModalImage(index);
  };

  // navigation button function
  // mobile image nav buttons
  const [mobileImgNav, setMobileImgNav] = useState(0);
  const mobileNextImg = (n) => {
    // map through the image to define the similar image in the array
    let mapImg = galleryArray.map((img) => {
      return activeImage === img ? (img = true) : null;
    });
    // let the number for the mobile image equal the index number in the array
    let mobileImgNav = mapImg.indexOf(true);
    // set the variable show to equal the sum which is the position in the array
    let show = mobileImgNav + n;
    if (show < 0) {
      show = 3;
    } else if (show > 3) {
      show = 0;
    }
    // when user clicks on the images, the position from the array will update
    setMobileImgNav(show);
    // display as active image
    setActiveImage(galleryArray[show]);
  };

  // desktop image modal
  const [imageNav, setImgNav] = useState(0);
  const nextImg = (n) => {
    let mapImg = galleryArray.map((img) => {
      return activeModalImage === img ? (img = true) : null;
    });
    let imageNav = mapImg.indexOf(true);
    let show = imageNav + n;
    if (show < 0) {
      show = 3;
    } else if (show > 3) {
      show = 0;
    }
    setImgNav(show);
    setActiveModalImage(galleryArray[show]);
  };

  return (
    <main>
      <div className="gallery">
        <div className="main-image">
          <button onClick={togglePhotoModal}>
            <img className="previewed-img" src={activeImage} alt="item image" />
          </button>
          <div className="navigation-btns">
            <button className="prev" onClick={() => mobileNextImg(-1)}>
              <img src={PrevBtn} alt="previous button" />
            </button>
            <button className="next" onClick={() => mobileNextImg(1)}>
              <img src={NextBtn} alt="next button" />
            </button>
          </div>
        </div>
        <div className="photo-options">
          <button
            className={`img img-1 ${activeImage === Image1 ? "selected" : ""}`}
            onClick={() => adjustActiveImage(galleryArray[0])}
          ></button>
          <button
            className={`img img-2 ${activeImage === Image2 ? "selected" : ""}`}
            onClick={() => adjustActiveImage(galleryArray[1])}
          ></button>
          <button
            className={`img img-3 ${activeImage === Image3 ? "selected" : ""}`}
            onClick={() => adjustActiveImage(galleryArray[2])}
          ></button>
          <button
            className={`img img-4 ${activeImage === Image4 ? "selected" : ""}`}
            onClick={() => adjustActiveImage(galleryArray[3])}
          ></button>
        </div>
      </div>
      <div className="description">
        <div className="info">
          <p className="company">
            Tag Me 1.0 (Your Location-based Attendance Marker)
          </p>
          <h1>Download Now</h1>
          <p className="item-info">
            Tag Me is an innovative app designed to simplify attendance tracking
            for various events and activities. With a user-friendly interface
            and robust features, Tag Me makes it easy for users to mark their
            attendance accurately.
          </p>
          <div className="description-btn">
            <div className="wrapper">
              <Android style={{ fontSize: 40, color: "#3DDC84" }}>
                android
              </Android>
              <h6 style={{ fontSize: "1" }}>Android 9+</h6>
            </div>
            <button className="add-to-cart" onClick={() => download()}>
              <IconButton color="primary" aria-label="Download ARM APK">
                <DownloadIcon />
                <div style={{ padding: "0 10px 0 10px" }}>Download</div>
              </IconButton>
            </button>
          </div>
        </div>
      </div>
      {/* ===========================modal=========================== */}
      <div
        className="images-modal"
        style={photoModal ? null : { display: `none` }}
      >
        <div className="modal-bg" onClick={togglePhotoModal}></div>
        <div className="wrapper">
          <div className="modal-gallery">
            <button className="close-btn" onClick={togglePhotoModal}>
              <img src={ClosePrev} alt="close" />
            </button>
            <div className="modal-preview">
              <img
                className="previewed-img"
                src={activeModalImage}
                alt="item image"
              />
              <div className="navigation-btns">
                <button className="prev" onClick={() => nextImg(-1)}>
                  <img src={PrevBtn} alt="previous button" />
                </button>
                <button className="next" onClick={() => nextImg(1)}>
                  <img src={NextBtn} alt="next button" />
                </button>
              </div>
            </div>
            <div className="photo-options">
              <button
                className={`img img-1 ${
                  activeModalImage === Image1 ? "selected" : ""
                }`}
                onClick={() => adjustActiveModalImage(Image1)}
              ></button>
              <button
                className={`img img-2 ${
                  activeModalImage === Image2 ? "selected" : ""
                }`}
                onClick={() => adjustActiveModalImage(Image2)}
              ></button>
              <button
                className={`img img-3 ${
                  activeModalImage === Image3 ? "selected" : ""
                }`}
                onClick={() => adjustActiveModalImage(Image3)}
              ></button>
              <button
                className={`img img-4 ${
                  activeModalImage === Image4 ? "selected" : ""
                }`}
                onClick={() => adjustActiveModalImage(Image4)}
              ></button>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
};

export default Hero;
