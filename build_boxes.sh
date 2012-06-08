#! /bin/bash

# see for the right order here
boxes=(basebox setupbox productionbox testbox developmentbox stagebox)

# set VAGRANT_LOG=DEBUG
# set VAGRANT_LOG=INFO
# set VAGRANT_LOG=

boxes_list() {
  echo "boxes: ${boxes[@]}"
  echo "To edit the list of boxes, please see line 3 in this file"
}

box_start() {
  if [ ! -n "$1" ]; then
    echo "Usage: box start <box>"
    boxes_list
    exit
  fi

  box="$1"
  echo_this="[box_start][$box]"

  echo "$echo_this vagrant up"

  pushd boxes/$box >/dev/null
    vagrant up
  popd >/dev/null
}

box_status() {
  if [ ! -n "$1" ]; then
    echo "Usage: box status <box>"
    boxes_list
    exit
  fi

  box="$1"

  pushd boxes/$box >/dev/null

  echo "[$box] vagrant status"
  vagrant status

  popd >/dev/null
}

boxes_status() {
  for box in ${boxes[@]}; do
    box_status $box
  done
}

box_destroy() {
  if [ ! -n "$1" ]; then
    echo "Usage: box destroy <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd boxes/$box >/dev/null
    vagrant destroy -f
  popd >/dev/null
}

boxes_destroy() {
  for box in ${boxes[@]}; do
    box_destroy $box
  done
}

box_stop() {
  if [ ! -n "$1" ]; then
    echo "Usage: box stop <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd boxes/$box >/dev/null
    vagrant halt
  popd >/dev/null
}


boxes_stop() {
  for box in ${boxes[@]}; do
    box_stop $box
  done
}

box_base_remove() {
  if [ ! -n "$1" ]; then
    echo "Usage: box base remove <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd boxes/$box >/dev/null
    vagrant box remove $box
  popd >/dev/null
}

boxes_base_remove() {
  for box in ${boxes[@]}; do
    box_base_remove $box
  done
}

boxes_base_list() {
  vagrant box list
}

box_package() {
  if [ ! -n "$1" ]; then
    echo "Usage: box package <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd boxes/$box >/dev/null
    vagrant package $box --output $box.box
  popd >/dev/null
}

box_add() {
  if [ ! -n "$1" ]; then
    echo "Usage: box add <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd boxes/$box >/dev/null
    vagrant box add $box $box.box
  popd >/dev/null
}

box_remove_pack() {
  if [ ! -n "$1" ]; then
    echo "Usage: box remove_pack <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd boxes/$box >/dev/null
    rm -f $box.box
  popd >/dev/null
}

box_build() {
  if [ ! -n "$1" ]; then
    echo "Usage: box build <box>"
    boxes_list
    exit
  fi

  echo_this="[box_build][$1]"


  box=""
  # set $box
  for check_box in ${boxes[@]}; do
    if [ "$1" = "$check_box" ]; then
      echo "$echo_this Checking that box $check_box exists in list"
      box=$check_box
    fi
  done

  if [ ! -n "${box}" ]; then
    echo "$echo_this The box you chose '$1' is not existing. Please edit enabled boxes or check that the box you want to build exists"
    boxes_list
    exit
  fi

  box_status $box

  box_destroy $box

  box_base_remove $box

  box_start $box

  box_stop $box

  box_remove_pack $box

  box_package $box

  box_add $box

}

boxes_build() {

  for box in ${boxes[@]}; do
    box_build $box
  done
}

start() {

  case "$1" in
  'box')

    case "$2" in
    'build')
      box_build $3
      ;;
    'start')
      box_start $3
      ;;
    'stop')
      box_stop $3
      ;;
    'destroy')
      box_destroy $3
      ;;
    'remove_pack')
      box_remove_pack $3
      ;;
    'status')
      box_status $3
      ;;
    'base')
      case "$3" in
      'remove')
        box_base_destroy $4
        ;;
      *)
        echo "Usage: box base <option>
Options:
  - remove    remove box from list of added boxes
"
        ;;
      esac
      ;;
    *)
      echo "Usage: box <option>
Options:
  - build <box>         build a box
  - start <box>         start a box
  - stop <box>          halt a box
  - destroy <box>       destroy created box
  - remove_pack <box>   removes packed file
  - status <box>        show status of box
  - base                .. more options here
"
      ;;
    esac
    ;;
  'boxes')
    case "$2" in
    'build')
      boxes_build
      ;;
    'stop')
      boxes_stop
      ;;
    'destroy')
      boxes_destroy
      ;;
    'status')
      boxes_status
      ;;
    'list')
      boxes_list
      ;;
    'base')
      case "$3" in
      'remove')
        boxes_base_remove
        ;;
      'list')
        boxes_base_list
        ;;
      *)
        echo "Usage: boxes base <option>"
  - remove   remove all added boxes
  - list     list all added boxes
        ;;
      esac
      ;;
    *)
    echo "Usage: boxes <option>
Options:
  - build    build all boxes
  - stop     halt all boxes
  - destroy  destroy all boxes
  - status   show status of all boxes
  - list     list all enabled boxes
  - base     .. more options here
"
      ;;
    esac
    ;;
  *)
    echo "Usage: <box|boxes> <options>"
    ;;
  esac
}

start $@
